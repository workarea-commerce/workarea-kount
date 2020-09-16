require 'test_helper'

module Workarea
  module Kount
    class EventTest < Workarea::TestCase
      def test_create
        assert_instance_of(Kount::DmcEvent, Event.create(dmc_xml))
        assert_instance_of(Kount::WorkflowEvent, Event.create(workflow_xml))
      end

      private

        def dmc_xml
          xml = <<~XML
            <event>
              <name>DMC_ADDRESS_ADD</name>
              <key>
                <address_1>Street Address </address_1>
                <address_2>Optional Address </address_2>
                <city>City </city>
                <state>State </state>
                <postal_code>Postal Code </postal_code>
                <type>Address Type </type>
              </key>
              <old_value>null </old_value>
              <new_value>New Status </new_value>
              <agent>agent@email.com </agent>
              <occurred>2015-09-05 13:19:24 </occurred>
            </event>
          XML

          Nokogiri::XML.parse(xml).children.first
        end

        def workflow_xml
          xml = <<~XML
            <event>
              <name>WORKFLOW_STATUS_EDIT</name>
              <key order_number="D58470FCF0" site="DEFAULT">7JG1075ML345</key>
              <old_value>R</old_value>
              <new_value>A</new_value>
              <agent>SYSTEM@KOUNT.NET</agent>
              <occurred>2018-05-18 06:47:47.413756</occurred>
            </event>
          XML

          Nokogiri::XML.parse(xml).children.first
        end
    end
  end
end
