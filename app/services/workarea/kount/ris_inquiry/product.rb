module Workarea
  module Kount
    class RisInquiry::Product
      attr_reader :order_item

      def initialize(order_item)
        @order_item = order_item
      end

      def item
        order_item.sku
      end

      def type
        catalog_product.name
      end

      def description
        "#{catalog_product.name} - #{variant_description}".truncate(255)
      end

      def quantity
        order_item.quantity
      end

      def price
        order_item.unit_price_cents.floor
      end

        private

          def catalog_product
            @catalog_product ||=
              if order_item.product_attributes.present?
                Mongoid::Factory.from_db(Catalog::Product, order_item.product_attributes)
              else
                Catalog::Product.find_by_sku(order_item.sku)
              end
          end

          def variant
            catalog_product.variants.where(sku: order_item.sku).first
          end

          def variant_description
            variant
              .details
              .map { |key, value| "#{key}: #{value.join(',')}" }
              .flatten.join(', ')
          end
    end
  end
end
