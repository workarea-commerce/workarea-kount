module Workarea
  module Kount
    class EventBatch
      attr_reader :data, :xml

      delegate :errors, to: :xml

      def initialize(data)
        @data = data
        @xml = Nokogiri::XML.parse(@data)
      end

      def valid?
        errors.empty?
      end

      def process!
        events.each do |event|
          next unless %w(RISK_CHANGE_REPLY WORKFLOW_STATUS_EDIT).include?(event.name)

          event_string = event.xml.to_s.lines.map(&:strip).join
          ProcessReviewOrder.perform_async(event.order_id, event.approved?, event_string)
        end
      end

      private

        def events
          @events ||= begin
            return [] if errors.present?

            xml.xpath('events/event').map { |e| Workarea::Kount::Event.create(e) }
          end
        end
    end
  end
end
