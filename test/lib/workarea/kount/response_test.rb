require 'test_helper'

module Workarea
  module Kount
    class ResponseTest < Workarea::TestCase
      def test_json_response
        response = Response.new(kount_response)
        assert response.success?
      end

      def test_from_error
        response = Response.from_error(kount_error_response)
        expected_body = {
          "MODE"          => "E",
          "ERRO"          => "701",
          "ERROR_0"       => "701 NO_HDR",
          "ERROR_COUNT"   => "1",
          "WARNING_COUNT" => "0"
        }
        assert_equal(expected_body, response.body)
      end

      private

        def kount_response
          {
            "VERS"               => "0630",
            "MODE"               => "Q",
            "TRAN"               => "7JMZ092R3BMX",
            "MERC"               => "200755",
            "SESS"               => "12345666",
            "ORDR"               => "1234",
            "AUTO"               => "A",
            "SCOR"               => "34",
            "GEOX"               => "US",
            "BRND"               => "VISA",
            "REGN"               => "US_PA",
            "NETW"               => "N",
            "KAPT"               => "N",
            "CARDS"              => "1",
            "DEVICES"            => "1",
            "EMAILS"             => "1",
            "VELO"               => "0",
            "VMAX"               => "0",
            "SITE"               => "DEFAULT",
            "DEVICE_LAYERS"      => "....",
            "FINGERPRINT"        => nil,
            "TIMEZONE"           => nil,
            "LOCALTIME"          => " ",
            "REGION"             => nil,
            "COUNTRY"            => nil,
            "PROXY"              => nil,
            "JAVASCRIPT"         => nil,
            "FLASH"              => nil,
            "COOKIES"            => nil,
            "HTTP_COUNTRY"       => nil,
            "LANGUAGE"           => nil,
            "MOBILE_DEVICE"      => nil,
            "MOBILE_TYPE"        => nil,
            "MOBILE_FORWARDER"   => nil,
            "VOICE_DEVICE"       => nil,
            "PC_REMOTE"          => nil,
            "RULES_TRIGGERED"    => 0,
            "COUNTERS_TRIGGERED" => 0,
            "REASON_CODE"        => nil,
            "MASTERCARD"         => "",
            "DDFS"               => nil,
            "DSR"                => nil,
            "UAS"                => nil,
            "BROWSER"            => nil,
            "OS"                 => nil,
            "PIP_IPAD"           => nil,
            "PIP_LAT"            => nil,
            "PIP_LON"            => nil,
            "PIP_COUNTRY"        => nil,
            "PIP_REGION"         => nil,
            "PIP_CITY"           => nil,
            "PIP_ORG"            => nil,
            "IP_IPAD"            => nil,
            "IP_LAT"             => nil,
            "IP_LON"             => nil,
            "IP_COUNTRY"         => nil,
            "IP_REGION"          => nil,
            "IP_CITY"            => nil,
            "IP_ORG"             => nil,
            "WARNING_COUNT"      => 0,
          }
        end

        def kount_error_response
          "MODE=E\nERRO=701\nERROR_0=701 NO_HDR\nERROR_COUNT=1\nWARNING_COUNT=0"
        end
    end
  end
end
