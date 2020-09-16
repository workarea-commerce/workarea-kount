module Workarea
  module Kount
    class RisInquiry < RisRequest
      attr_reader :shippings, :request_user_defined_fields

      def initialize(order:, payment:, shippings:, mode: 'Q', request_user_defined_fields: {})
        @order                       = order
        @payment                     = payment
        @shippings                   = shippings
        @mode                        = mode
        @request_user_defined_fields = request_user_defined_fields
      end

      def to_h
        @to_h ||=
          begin
            inquiry_hash = [
              base_fields,
              shipping_address,
              billing_address,
              tender,
              shipping_service,
              order_total,
              build_personal,
              cart_fields
            ].reduce(&:merge)

            user_defined_fields.each do |key, value|
              inquiry_hash.merge!("UDF[#{key}]" => value)
            end

            inquiry_hash
          end
      end

      private

        def base_fields
          super.merge(SITE: Kount.kount_site)
        end

        def order_total
          {
            TOTL: order.total_price.cents,
            CURR: order.total_price.currency.iso_code
          }
        end

        def build_personal
          {
            EMAL: order.email,
            NAME: [payment.first_name, payment.last_name].join(' '),
            IPAD: order.ip_address,
            ORDR: order.id
          }
        end

        def shipping_address
          return {} unless order.requires_shipping?
          Workarea::Kount::Address.for_shipping(shippings.first.address)
        end

        def billing_address
          Workarea::Kount::Address.for_billing(payment.address)
        end

        def shipping_service
          return {} unless order.requires_shipping? &&
            shippings.first.shipping_service.try(:kount_code).try(:present?)

          { SHTP: shippings.first.shipping_service.kount_code }
        end

        def cart_fields
          cart = {
            PROD_TYPE:  [],
            PROD_DESC:  [],
            PROD_ITEM:  [],
            PROD_PRICE: [],
            PROD_QUANT: []
          }
          order.items.each do |order_item|
            ris_product = RisInquiry::Product.new(order_item)
            cart[:PROD_TYPE]  << ris_product.type
            cart[:PROD_DESC]  << ris_product.description
            cart[:PROD_ITEM]  << ris_product.item
            cart[:PROD_PRICE] << ris_product.price
            cart[:PROD_QUANT] << ris_product.quantity
          end

          cart
        end

        def user_defined_fields
          Workarea::Kount::UserDefinedFields.new(request_user_defined_fields).fields
        end

        def tender
          if payment.credit_card? && payment.credit_card.number.present?
            {
              PTYP: Kount::PaymentTypes::CREDIT_CARD,
              PTOK: Kount::SecurityMash.hash_credit_card(payment.credit_card.number, Kount.ksalt),
              PENC: "KHASH"
            }
          elsif payment.credit_card? && payment.credit_card.token.present?
            {
              PTYP: Kount::PaymentTypes::TOKEN,
              PTOK: Kount::SecurityMash.hash_credit_card(payment.credit_card.token, Kount.ksalt),
              PENC: "KHASH"
            }
          elsif Workarea::Plugin.installed?('Paypal') && payment.paypal?
            {
              PTYP: Kount::PaymentTypes::PAYPAL,
              PTOK: payment.paypal.payer_id
            }
          end
        end
    end
  end
end
