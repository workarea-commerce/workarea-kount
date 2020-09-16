require 'test_helper'

module Workarea
  module Kount
    class EventBatchTest < Workarea::TestCase
      setup :setup_sidekiq
      teardown :teardown_sidekiq

      def test_valid_with_valid_xml
        event_batch = EventBatch.new(valid_xml)
        assert(event_batch.valid?)
      end

      def test_valid_with_invalid_xml
        event_batch = EventBatch.new(invalid_xml)
        refute(event_batch.valid?)
      end

      def test_process_with_valid_xml
        event_batch = EventBatch.new(valid_xml)
        assert_difference 'Workarea::Kount::ProcessReviewOrder.jobs.count', 2 do
          event_batch.process!
        end
      end

      def test_process_with_invalid_xml
        event_batch = EventBatch.new(invalid_xml)
        assert_difference 'Workarea::Kount::ProcessReviewOrder.jobs.count', 0 do
          event_batch.process!
        end
      end

      private

        def valid_xml
          <<~XML
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
              <key order_number="D58470FCF0" site="DEFAULT">7JG601D6MG7S</key>
              <old_value>R</old_value>
              <new_value>D</new_value>
              <agent>SYSTEM@KOUNT.NET</agent>
              <occurred>2018-05-18 06:47:59.252024</occurred>
            </event>
          </events>
          XML
        end

        def invalid_xml
          <<~XML
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
        end

        def setup_sidekiq
          Sidekiq::Testing.fake!

          Workarea::Kount::ProcessReviewOrder.clear
        end

        def teardown_sidekiq
          Workarea::Kount::ProcessReviewOrder.clear
          Sidekiq::Testing.inline!
        end
    end
  end
end
