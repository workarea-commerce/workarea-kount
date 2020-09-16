require 'test_helper'

module Workarea
  if Workarea::Plugin.installed?(:moneris)
    class KountMonerisIntegrationTest < Workarea::TestCase
      include KountApiConfig
      include MonerisGatewayVCRConfig

      def test_new_credit_card
        VCR.use_cassette 'kount/integration/moneris_new_credit_card' do
          checkout = create_purchasable_checkout(order: {
            kount_session_id: '12345666',
            ip_address: '170.115.187.68'
          })

          response = Kount::OrderFraudService.new(
            order: checkout.order,
            payment: checkout.payment,
            shippings: checkout.shippings
          ).perform!

          assert response.success?
        end
      end

      def test_saved_credit_card
        VCR.use_cassette 'kount/integration/moneris_saved_credit_card' do
          checkout = create_purchasable_checkout(
            order: {
              kount_session_id: '12345666',
              ip_address: '170.115.187.68'
            },
            payment: "saved_card"
          )

          response = Kount::OrderFraudService.new(
            order: checkout.order,
            payment: checkout.payment,
            shippings: checkout.shippings
          ).perform!

          assert response.success?
        end
      end
    end
  end
end
