# frozen_string_literal: true

module Workarea
  class Checkout
    module Fraud
      class KountAnalyzer < Analyzer
        # This is the `:mode` value used in the RIS Inquiry request to
        # Kount. It tells Kount that this is a new order, and not an
        # update to an existing order as used in the updater service
        # class.
        #
        # @return [String]
        MODE_Q = 'Q'

        delegate :gateway, to: Workarea::Kount
        delegate :kount_mode, :kount_request_user_defined_fields, to: :checkout
        delegate :decision, to: :kount_response

        # Tell Kount about the order and record its response.
        #
        # @return [Workarea::Order::FraudDecision]
        def make_decision
          kount_order.update_attributes!(response: kount_response)

          Workarea::Order::FraudDecision.new(
            decision: decision,
            message: message
          )
        end

        # Data for this Order from Kount.
        #
        # @return [Workarea::Kount::Order]
        def kount_order
          @kount_order ||= Workarea::Kount::Order.find_or_initialize_by(id: order.id)
        end

        private

        # Build the RIS inquiry request.
        #
        # @private
        # @return [Hash]
        def inquiry
          Workarea::Kount::RisInquiry.new(
            order: order,
            payment: payment,
            shippings: shippings,
            mode: MODE_Q
          ).to_h
        end

        # Response for the Kount RIS inquiry request.
        #
        # @private
        # @return [Workarea::Kount::Response]
        def kount_response
          @kount_response ||= gateway.call(inquiry)
        end

        # Translated message for the Kount decision.
        #
        # @private
        # @return [String]
        def message
          I18n.t(decision, scope: 'workarea.storefront.fraud.kount')
        end
      end
    end
  end
end
