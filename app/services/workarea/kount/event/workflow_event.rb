module Workarea
  module Kount
    class WorkflowEvent < Event
      def type
        :workflow
      end

      def order_id
        @order_id ||= xml.xpath('key').attribute('order_number').text
      end

      def site_id
        @order_id ||= xml.xpath('key').attribute('site').text
      end

      def trasnaction_id
        @trasnaction_id ||= xml.path('key').text
      end

      def approved?
        new_value == "A"
      end
    end
  end
end
