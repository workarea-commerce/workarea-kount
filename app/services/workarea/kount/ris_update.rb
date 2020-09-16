module Workarea
  module Kount
    class RisUpdate < RisRequest
      attr_reader :options

      def initialize(order:, payment:, mode: 'U', options: {})
        @order   = order
        @payment = payment
        @mode    = mode
        @options = options
      end

      def to_h
        @to_h ||= [
          base_fields,
          kount_transaction_id,
          avs_response,
          cvv_response
        ].reduce(&:merge)
      end

      def payment_transaction
        @payment_transaction = options[:payment_transaction] ||
          authorization_transaction
      end

      private

        def kount_order
          @kount_order ||= options[:kount_order] ||
            Workarea::Kount::Order.find(order.id)
        end

        def kount_transaction_id
          { TRAN: kount_order.response.transaction_id }
        end
    end
  end
end
