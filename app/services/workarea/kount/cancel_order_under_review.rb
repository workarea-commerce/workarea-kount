module Workarea
  module Kount
    class CancelOrderUnderReview
      attr_reader :order

      def initialize(order)
        @order = order
      end

      def cancel!
        cancel_order_service.perform
        cancel_order_side_effects
      end

      private

        def cancel_order_service
          @cancel_order_service ||= Workarea::CancelOrder.new(order, restock: true)
        end

        def cancel_order_side_effects
          Workarea::Storefront::OrderMailer.hold_denial(order.id).deliver_now
          order.update_attributes!(kount_decision: :decline)
          Workarea::IndexAdminSearch.perform(order)
        end
    end
  end
end
