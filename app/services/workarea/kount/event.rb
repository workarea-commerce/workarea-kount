module Workarea
  module Kount
    class Event
      def self.create(xml)
        name = xml.xpath('name').text

        case name
        when /^DMC_/           then DmcEvent.new(name, xml)
        when /^RISK_CHANGE_/   then RiskChangeEvent.new(name, xml)
        when /^WORKFLOW_/      then WorkflowEvent.new(name, xml)
        when /^SPECIAL_ALERT_/ then SpecialAlertEvent.new(name, xml)
        end
      end

      attr_reader :name, :xml

      def initialize(name, xml)
        @name = name
        @xml = xml
      end

      def key
        @key ||= xml.xpath('key').text
      end

      def old_value
        @old_value ||= xml.xpath('old_value').text
      end

      def new_value
        @new_value ||= xml.xpath('new_value').text
      end

      def agent
        @agent ||= xml.xpath('agent').text
      end

      def occurred
        @occurred ||= xml.xpath('occurred').text
      end
    end
  end
end
