require 'test_helper'

module Workarea
  module Kount
    class OrderFraudUpdateServiceTest < Workarea::TestCase
      setup :setup_sandbox_credentials
      teardown :restore_credentials

      def test_update_with_auth
        VCR.use_cassette('kount/order_fraud_update') do
          checkout = create_purchasable_checkout(order: {
            kount_session_id: '12345666',
            ip_address: '170.115.187.68'
          })

          assert(checkout.place_order)

          update_response = OrderFraudUpdateService.new(
            order: checkout.order,
            payment: checkout.payment
          ).perform!

          assert(update_response.success?)
        end
      end

      private

        def setup_sandbox_credentials
          @_old_credentials = Workarea::Kount.credentials

          Rails.application.secrets.kount = {
            merchant_id: '200755',
            version: '0630',
            key: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIyMDA3NTUiLCJhdWQiOiJLb3VudC4xIiwiaWF0IjoxNTAwNDA3NTE1LCJzY3AiOnsia2EiOm51bGwsImtjIjpudWxsLCJhcGkiOnRydWUsInJpcyI6dHJ1ZX19.1YwTR1G8qBQ_TDK8MBYxDB2EhpUD0IlwWdvqHVOnm0o',
            ksalt: '4077th hawkeye trapper radar section-8',
            is_test: true
          }

          Workarea.config.fraud_analyzer = 'Workarea::Checkout::Fraud::KountAnalyzer'
        end

        def restore_credentials
          Rails.application.secrets.kount = @_old_credentials
        end
    end
  end
end
