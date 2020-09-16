module Workarea
  module Kount
    class SpecialAlertEvent < Event
      def type
        :special_alert
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
    end
  end
end
