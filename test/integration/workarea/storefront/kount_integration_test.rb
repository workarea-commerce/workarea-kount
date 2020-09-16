require 'test_helper'

module Workarea
  module Storefront
    class KountIntegrationTest < Workarea::IntegrationTest
      setup :mock_kount_order

      def test_redirects_to_kount_data_collector_htm_path
        get '/logo.htm'

        assert_redirected_to("#{Workarea::Kount.data_collector_url}logo.htm?#{{ merchant_id: Workarea::Kount.merchant_id, s: kount_session_id }.to_query }")
      end

      def test_redirects_to_kount_data_collector_gif_path
        get '/logo.gif'

        assert_redirected_to("#{Workarea::Kount.data_collector_url}logo.htm?#{{ merchant_id: Workarea::Kount.merchant_id, s: kount_session_id }.to_query }")
      end

      private

        def mock_kount_order
          order = create_order

          Workarea::Storefront::KountController
          .any_instance.stubs(:current_order).returns(order)

          Workarea::Storefront::KountController
          .any_instance.stubs(:kount_session_id).returns(kount_session_id)
        end

        def kount_session_id
          @kount_session_id ||= '1234-092340423-52341'
        end
    end
  end
end
