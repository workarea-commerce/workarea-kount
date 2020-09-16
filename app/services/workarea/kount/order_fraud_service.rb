module Workarea
  module Kount
    class OrderFraudService
      delegate :gateway, to: Workarea::Kount

      attr_reader :order, :payment, :shippings, :mode, :request_user_defined_fields

      def initialize(order:, payment:, shippings:, mode: 'Q', request_user_defined_fields: {})
        @order = order
        @payment = payment
        @shippings = shippings
        @mode = mode
        @request_user_defined_fields = request_user_defined_fields
      end

      def perform!
        kount_order.update_attributes!(response: kount_response)
        kount_response
      end

      def kount_order
        @kount_order ||= Workarea::Kount::Order.find_or_initialize_by(id: order.id)
      end

      private

        def inquiry
          Workarea::Kount::RisInquiry.new(
            order: order,
            payment: payment,
            shippings: shippings,
            mode: mode,
            request_user_defined_fields: request_user_defined_fields
          ).to_h
        end

        def kount_response
          @kount_response ||= gateway.call(inquiry)
        end
    end
  end
end
