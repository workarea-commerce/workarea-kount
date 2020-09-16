module Workarea
  module Kount
    class OrderFraudUpdateService
      delegate :gateway, to: Workarea::Kount

      attr_reader :order, :payment, :mode, :options

      def initialize(order:, payment:, mode: 'U', options: {})
        @order   = order
        @payment = payment
        @mode    = mode
        @options = options
      end

      def perform!
        kount_order.update_attributes!(update_response: kount_response)
        kount_response
      end

      def kount_order
        @kount_order ||= Workarea::Kount::Order.find(order.id)
      end

      private

        def update
          Workarea::Kount::RisUpdate.new(
            order: order,
            payment: payment,
            mode: mode,
            options: options.merge(
              kount_order: kount_order
            )
          ).to_h
        end

        def kount_response
          @kount_response ||= gateway.call(update)
        end
    end
  end
end
