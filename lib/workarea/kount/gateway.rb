module Workarea
  module Kount
    class Gateway
      delegate :merchant_id, :key, :ksalt, to: Workarea::Kount
      attr_reader :options

      RESPONSE_FORMAT = 'JSON'

      VERSION = '0630'
      ENDPOINT_PROD = 'https://risk.kount.net'
      ENDPOINT_TEST = 'https://risk.test.kount.net'

      def initialize(options = {})
        @options = options
      end

      def call(body)
        body = body.merge(VERS: VERSION, MERC: Kount.merchant_id, FRMT: RESPONSE_FORMAT)

        response = RestClient::Resource
          .new(endpoint, verify_ssl: verify_ssl_option, timeout: 1)
          .post(body, x_kount_api_key: Kount.key)

        begin
          Response.new(JSON.parse(response))
        rescue
          Response.from_error(response.body)
        end
      end

      private

        def test?
          options.fetch(:is_test, false)
        end

        def endpoint
          test? ? ENDPOINT_TEST : ENDPOINT_PROD
        end

        def verify_ssl_option
          if test?
            OpenSSL::SSL::VERIFY_NONE
          else
            OpenSSL::SSL::VERIFY_PEER
          end
        end
    end
  end
end
