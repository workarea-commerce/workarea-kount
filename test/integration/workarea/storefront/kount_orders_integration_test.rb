require 'test_helper'

module Workarea
  module Storefront
    class KountOrdersIntegationTest < Workarea::IntegrationTest
      setup :setup_kount_basic_auth_credentials
      teardown :restore_credentials

      def test_bulk_events_with_valid_xml
        xml = <<~XML
         <?xml version="1.0" encoding="UTF-8" standalone="no"?>
          <events merchant="200755" total="2">
            <event>
              <name>WORKFLOW_STATUS_EDIT</name>
              <key order_number="D58470FCF0" site="DEFAULT">7JG1075ML345</key>
              <old_value>R</old_value>
              <new_value>A</new_value>
              <agent>SYSTEM@KOUNT.NET</agent>
              <occurred>2018-05-18 06:47:47.413756</occurred>
            </event>
            <event>
              <name>WORKFLOW_STATUS_EDIT</name>
              <key order_number="D58470FCF1" site="DEFAULT">7JG601D6MG7S</key>
              <old_value>R</old_value>
              <new_value>D</new_value>
              <agent>SYSTEM@KOUNT.NET</agent>
              <occurred>2018-05-18 06:47:59.252024</occurred>
            </event>
          </events>
          XML

        Kount::ProcessReviewOrder.expects(:perform_async)
        Kount::ProcessReviewOrder.expects(:perform_async)

        post storefront.kount_orders_path, params: xml, headers: auth_headers
        assert(response.ok?)
        assert_equal({ "status" => 200 }, JSON.parse(response.body))
        assert_equal(200, response.status)
      end

      def test_bulk_events_with_invalid_xml
        xml = <<~XML
         <?xml version="1.0" encoding="UTF-8" standalone="no"?
          <events merchant="200755" total="2">
            <event>
              <name>WORKFLOW_STATUS_EDIT</name>
              <key order_number="D58470FCF0" site="DEFAULT">7JG1075ML345</key>
              <old_value>R</old_value>
              <new_value>A</new_value>
              <agent>SYSTEM@KOUNT.NET</agent>
              <occurred>2018-05-18 06:47:47.413756</occurred>
            </event>
            <event>
              <name>WORKFLOW_STATUS_EDIT</name>
              <key order_number="D58470FCF0" site="DEFAULT">7JG601D6MG7S</key>
              <old_value>R</old_value>
              <new_value>D</new_value>
              <agent>SYSTEM@KOUNT.NET</agent>
              <occurred>2018-05-18 06:47:59.252024</occurred>
            </event>
          </events>
          XML

        post storefront.kount_orders_path, params: xml, headers: auth_headers
        refute(response.ok?)
        assert_equal(400, response.status)
      end

      private

        def setup_kount_basic_auth_credentials
          @_old_credentials = Workarea::Kount.credentials

          Rails.application.secrets.kount = {
            ens_username: "kount",
            ens_password: "password"
          }
        end

        def restore_credentials
          Rails.application.secrets.kount = @_old_credentials
        end

        def auth_headers
          { "Authorization" => "Basic #{Base64.encode64('kount:password')}" }
        end
    end
  end
end
