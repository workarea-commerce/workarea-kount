module Workarea
  module Kount
    class Response
      attr_reader :body
      delegate :keys, :[], to: :body

      def self.from_error(error_string)
        body = error_string.strip.split("\n").each_with_object({}) do |string, response|
          key, value = string.split("=")
          response[key] = value
        end

        Response.new(body)
      end

      def initialize(body)
        @body = body
      end

      def result_hash
        @result_hash ||=
          begin
            body_dup          = body.dup
            rule_ids          = []
            rule_descriptions = []

            errors            = []
            warnings          = []

            body_dup.each do |key, value|
              if key =~ /^RULE_ID_(\d+)/
                rule_ids[$1.to_i] = value
                body_dup.delete(key)
              end

              if key =~ /^RULE_DESCRIPTION_(\d+)/
                rule_descriptions[$1.to_i] = value
                body_dup.delete(key)
              end

              if key =~ /^WARNING_(\d+)/
                warnings[$1.to_i] = value
                body_dup.delete(key)
              end

              if key =~ /^ERROR_(\d+)/
                errors[$1.to_i] = value
                body_dup.delete(key)
              end
            end

            if rule_ids.present?
              rules = rule_ids.each_with_index.map do |rule_id, i|
                { rule_id: rule_id, rule_description: rule_descriptions[i] }
              end
            end

            response_values = body_dup.map do |key, value|
              [
                Workarea::Kount::Mappings::RESPONSE_MAPPING.fetch(key, key),
                value
              ]
            end.to_h

            response_values.merge(
              rules:        rules,
              errors_kount: errors, # this was named this way, b/c of how ActiveRecord handles "errors=", ugh!
              warnings:     warnings
            )
          end
      end

      def triggered_rules
        result_hash[:rules]
      end

      # Symbol for the decision made by Kount
      #
      # Returns a symbol for the decision made by Kount
      def decision
        Workarea::Kount::Mappings::AUTO_MAPPING.fetch(result_hash["AUTO"], :approve)
      end

      def transaction_id
        body["TRAN"]
      end

      def success?
        body["MODE"] != "E" && result_hash["ERROR_COUNT"].to_i == 0
      end

      def score
        body["SCOR"]
      end

      def credit_cards
        body["CARDS"]
      end

      def email_addresses
        body["EMAILS"]
      end

      def devices
        body["DEVICES"]
      end

      def mongoize
        body
      end

      class << self
        def demongoize(object)
          return nil if object.blank?

          Response.new(object)
        end

        def mongoize(object)
          case object
          when Response then object.mongoize
          else object
          end
        end

        def evolve(object)
          raise 'querying on an Workarea::Kount::Response is unsupported at this time'
        end
      end

      private

        # Takes the raw_response and parses it to key values for the
        # keyvalue format
        #
        # Returns a hash of key values
        def parsed_response
        end
    end
  end
end
