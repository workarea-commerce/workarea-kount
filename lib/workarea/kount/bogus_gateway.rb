module Workarea
  module Kount
    class BogusGateway
      def call(inquiry)
        mode = inquiry[:MODE]

        body =
          if mode == "U"
            update_response
          else
            type = inquiry[:PTYP]
            number = inquiry[:PTOK]
            email = inquiry[:EMAL]


              case type
              when 'CARD', 'TOKEN'
                credit_card(number, email: email)
              when 'PYPL'
                paypal
              when 'GIFT'
                gift_card
              when 'NONE'
                store_credit
              else
                raise Workarea::Kount::Errors::PaymentNotSupportedError, "#{type} is not supported by Kount."
              end
          end

        Kount::Response.new(body)
      end

      private

      def credit_card_decline
        {
          "VERSION"                 => "0630",
          "MODE"                    => "Q",
          "TRANSACTION_ID"          => "6V100HV36D98",
          "MERCHANT_ID"             => "158000",
          "SESSION_ID"              => "1",
          "ORDER_ID"                => "1",
          "AUTO"                    => "D",
          "SCOR"                    => "42",
          "WORST_CONTRY_ASSOCIATED" => "NG",
          "PAYMENT_BRAND"           => "VISA",
          "REGION"                  => "ID",
          "NETWORK"                 => "A",
          "CARDS"                   => 2,
          "DEVICES"                 => 1,
          "EMAILS"                  => 3,
          "VELOCITY"                => 4,
          "VMAX"                    => 4,
          "SITE"                    => "DEFAULT",
          "DEVICE_LAYERS"           => "D67BC18BAD.6EF0902E51.8C96FA9E7B.61FD602D96.940A6D1454",
          "FINGERPRINT"             => "00482B9BED15A272730FCB590FFEBDDD",
          "TIMEZONE"                => 420,
          "LOCALTIME"               => "2015-11-12 12:15",
          "COUNTRY"                 => "US",
          "PROXY"                   => "N",
          "JAVASCRIPT"              => "Y",
          "FLASH"                   => "Y",
          "COOKIES"                 => "Y",
          "HTTP_COUNTRY"            => "US",
          "LANGUAGE"                => "EN",
          "MOBILE_DEVICE"           => "N",
          "MOBILE_TYPE"             => "",
          "MOBILE_FORWARDER"        => "N",
          "VOICE_DEVICE"            => "N",
          "PC_REMOTE"               => "N",
          "RULES_TRIGGERED"         => 0,
          "COUNTERS_TRIGGERED"      => 0,
          "IL"                      => "Kount Inc.",
          "WARNING_COUNT"           => 0,
          "RULES"                   => nil,
          "ERRORS_KOUNT"            => [],
          "WARNINGS"                => []
        }
      end

      def credit_card_review
        {
          "VERSION"                 => "0630",
          "MODE"                    => "Q",
          "TRANSACTION_ID"          => "6V100HV36D98",
          "MERCHANT_ID"             => "158000",
          "SESSION_ID"              => "1",
          "ORDER_ID"                => "1",
          "AUTO"                    => "R",
          "SCOR"                    => 50,
          "WORST_CONTRY_ASSOCIATED" => "US",
          "PAYMENT_BRAND"           => "VISA",
          "REGION"                  => "ID",
          "NETWORK"                 => "A",
          "CARDS"                   => 2,
          "DEVICES"                 => 1,
          "EMAILS"                  => 3,
          "VELOCITY"                => 4,
          "VMAX"                    => 4,
          "SITE"                    => "DEFAULT",
          "DEVICE_LAYERS"           => "D67BC18BAD.6EF0902E51.8C96FA9E7B.61FD602D96.940A6D1454",
          "FINGERPRINT"             => "00482B9BED15A272730FCB590FFEBDDD",
          "TIMEZONE"                => 420,
          "LOCALTIME"               => "2015-11-12 12:15",
          "COUNTRY"                 => "US",
          "PROXY"                   => "N",
          "JAVASCRIPT"              => "Y",
          "FLASH"                   => "Y",
          "COOKIES"                 => "Y",
          "HTTP_COUNTRY"            => "US",
          "LANGUAGE"                => "EN",
          "MOBILE_DEVICE"           => "N",
          "MOBILE_TYPE"             => "",
          "MOBILE_FORWARDER"        => "N",
          "VOICE_DEVICE"            => "N",
          "PC_REMOTE"               => "N",
          "RULES_TRIGGERED"         => 0,
          "COUNTERS_TRIGGERED"      => 0,
          "IL"                      => "Kount Inc.",
          "WARNING_COUNT"           => 0,
          "RULES"                   => nil,
          "ERRORS_KOUNT"            => [],
          "WARNINGS"                => []
        }
      end

      def credit_card_approve
        {
          "VERSION"                 => "0630",
          "MODE"                    => "Q",
          "TRANSACTION_ID"          => "6V100HV36D98",
          "MERCHANT_ID"             => "158000",
          "SESSION_ID"              => "1",
          "ORDER_ID"                => "1",
          "AUTO"                    => "A",
          "SCORE"                   => 50,
          "WORST_CONTRY_ASSOCIATED" => "US",
          "PAYMENT_BRAND"           => "VISA",
          "REGION"                  => "ID",
          "NETWORK"                 => "A",
          "CARDS"                   => 2,
          "DEVICES"                 => 1,
          "EMAILS"                  => 3,
          "VELOCITY"                => 4,
          "VMAX"                    => 4,
          "SITE"                    => "DEFAULT",
          "DEVICE_LAYERS"           => "D67BC18BAD.6EF0902E51.8C96FA9E7B.61FD602D96.940A6D1454",
          "FINGERPRINT"             => "00482B9BED15A272730FCB590FFEBDDD",
          "TIMEZONE"                => 420,
          "LOCALTIME"               => "2015-11-12 12:15",
          "COUNTRY"                 => "US",
          "PROXY"                   => "N",
          "JAVASCRIPT"              => "Y",
          "FLASH"                   => "Y",
          "COOKIES"                 => "Y",
          "HTTP_COUNTRY"            => "US",
          "LANGUAGE"                => "EN",
          "MOBILE_DEVICE"           => "N",
          "MOBILE_TYPE"             => "",
          "MOBILE_FORWARDER"        => "N",
          "VOICE_DEVICE"            => "N",
          "PC_REMOTE"               => "N",
          "RULES_TRIGGERED"         => 0,
          "COUNTERS_TRIGGERED"      => 0,
          "IL"                      => "Kount Inc.",
          "WARNING_COUNT"           => 0,
          "RULES"                   => nil,
          "ERRORS_KOUNT"            => [],
          "WARNINGS"                => []
        }
      end

      def credit_card_other
        {
          "VERSION"                 => "0630",
          "MODE"                    => "Q",
          "TRANSACTION_ID"          => "6V100HV36D98",
          "MERCHANT_ID"             => "158000",
          "SESSION_ID"              => "1",
          "ORDER_ID"                => "1",
          "AUTO"                    => "A",
          "SCORE"                   => 50,
          "WORST_CONTRY_ASSOCIATED" => "US",
          "PAYMENT_BRAND"           => "VISA",
          "REGION"                  => "ID",
          "NETWORK"                 => "A",
          "CARDS"                   => 2,
          "DEVICES"                 => 1,
          "EMAILS"                  => 3,
          "VELOCITY"                => 4,
          "VMAX"                    => 4,
          "SITE"                    => "DEFAULT",
          "DEVICE_LAYERS"           => "D67BC18BAD.6EF0902E51.8C96FA9E7B.61FD602D96.940A6D1454",
          "FINGERPRINT"             => "00482B9BED15A272730FCB590FFEBDDD",
          "TIMEZONE"                => 420,
          "LOCALTIME"               => "2015-11-12 12:15",
          "COUNTRY"                 => "US",
          "PROXY"                   => "N",
          "JAVASCRIPT"              => "Y",
          "FLASH"                   => "Y",
          "COOKIES"                 => "Y",
          "HTTP_COUNTRY"            => "US",
          "LANGUAGE"                => "EN",
          "MOBILE_DEVICE"           => "N",
          "MOBILE_TYPE"             => "",
          "MOBILE_FORWARDER"        => "N",
          "VOICE_DEVICE"            => "N",
          "PC_REMOTE"               => "N",
          "RULES_TRIGGERED"         => 0,
          "COUNTERS_TRIGGERED"      => 0,
          "IL"                      => "Kount Inc.",
          "WARNING_COUNT"           => 0,
          "RULES"                   => nil,
          "ERRORS_KOUNT"            => [],
          "WARNINGS"                => []
        }
      end

      def credit_card(number, email: nil)
        if email.present?
          case email
          when "approve@workarea.com"
            return credit_card_approve
          when "review@workarea.com"
            return credit_card_review
          when "decline@workarea.com"
            return credit_card_decline
          end
        end

        case number
        when /21$/ # decline
          credit_card_decline
        when /31$/ # review
          credit_card_review
        when /1$/ # approve
          credit_card_approve
        else
          credit_card_other
        end
      end

      def paypal
        {
          :version => "0630",
          :mode => "Q",
          :transaction_id => "6V100HV36D98",
          :merchant_id => "158000",
          :session_id => "1",
          :order_id => "1",
          :auto => "A",
          :score => 50,
          :worst_contry_associated => "US",
          :payment_brand => "VISA",
          :region => "ID",
          :network => "A",
          :cards => 2,
          :devices => 1,
          :emails => 3,
          :velocity => 4,
          :vmax => 4,
          :site => "DEFAULT",
          :device_layers => "D67BC18BAD.6EF0902E51.8C96FA9E7B.61FD602D96.940A6D1454",
          :fingerprint => "00482B9BED15A272730FCB590FFEBDDD",
          :timezone => 420,
          :localtime => "2015-11-12 12:04",
          :country => "US",
          :proxy => "N",
          :javascript => "Y",
          :flash => "Y",
          :cookies => "Y",
          :http_country => "US",
          :language => "EN",
          :mobile_device => "N",
          :mobile_type => "",
          :mobile_forwarder => "N",
          :voice_device => "N",
          :pc_remote => "N",
          :rules_triggered => 0,
          :counters_triggered => 0,
          nil => "Kount Inc.",
          :warning_count => 0,
          :rules => nil,
          :errors_kount => [],
          :warnings => []
        }
      end

      def gift_card
        {
          :version => "0630",
          :mode => "Q",
          :transaction_id => "6V100HV36D98",
          :merchant_id => "158000",
          :session_id => "1",
          :order_id => "1",
          :auto => "A",
          :score => 50,
          :worst_contry_associated => "US",
          :payment_brand => "VISA",
          :region => "ID",
          :network => "A",
          :cards => 2,
          :devices => 1,
          :emails => 3,
          :velocity => 4,
          :vmax => 4,
          :site => "DEFAULT",
          :device_layers => "D67BC18BAD.6EF0902E51.8C96FA9E7B.61FD602D96.940A6D1454",
          :fingerprint => "00482B9BED15A272730FCB590FFEBDDD",
          :timezone => 420,
          :localtime => "2015-11-12 12:15",
          :country => "US",
          :proxy => "N",
          :javascript => "Y",
          :flash => "Y",
          :cookies => "Y",
          :http_country => "US",
          :language => "EN",
          :mobile_device => "N",
          :mobile_type => "",
          :mobile_forwarder => "N",
          :voice_device => "N",
          :pc_remote => "N",
          :rules_triggered => 0,
          :counters_triggered => 0,
          nil => "Kount Inc.",
          :warning_count => 0,
          :rules => nil,
          :errors_kount => [],
          :warnings => []
        }
      end

      def store_credit
        {
          AUTO:               "A",
          BRND:               "NONE",
          BROWSER:            nil,
          CARDS:              "1",
          COOKIES:            nil,
          COUNTERS_TRIGGERED: 0,
          COUNTRY:            nil,
          DDFS:               nil,
          DEVICES:            "1",
          DEVICE_LAYERS:      "....",
          DSR:                nil,
          EMAILS:             "1",
          FINGERPRINT:        nil,
          FLASH:              nil,
          GEOX:               "US",
          HTTP_COUNTRY:       nil,
          IP_CITY:            nil,
          IP_COUNTRY:         nil,
          IP_IPAD:            nil,
          IP_LAT:             nil,
          IP_LON:             nil,
          IP_ORG:             nil,
          IP_REGION:          nil,
          JAVASCRIPT:         nil,
          KAPT:               "N",
          LANGUAGE:           nil,
          LOCALTIME:          "",
          MASTERCARD:         "",
          MERC:               "200755",
          MOBILE_DEVICE:      nil,
          MOBILE_FORWARDER:   nil,
          MOBILE_TYPE:        nil,
          MODE:               "Q",
          NETW:               "N",
          ORDR:               "214EAF647E",
          OS:                 nil,
          PC_REMOTE:          nil,
          PIP_CITY:           nil,
          PIP_COUNTRY:        nil,
          PIP_IPAD:           nil,
          PIP_LAT:            nil,
          PIP_LON:            nil,
          PIP_ORG:            nil,
          PIP_REGION:         nil,
          PROXY:              nil,
          REASON_CODE:        nil,
          REGION:             nil,
          REGN:               "US_PA",
          RULES_TRIGGERED:    0,
          SCOR:               "29",
          SESS:               "12345666",
          SITE:               "DEFAULT",
          TIMEZONE:           nil,
          TRAN:               "7K700MYCC250",
          UAS:                nil,
          VELO:               "0",
          VERS:               "0630",
          VMAX:               "0",
          VOICE_DEVICE:       nil,
          WARNING_COUNT:      0
        }
      end

      def update_response
        {
          "VERSION"            => '0630',
          "MODE"               => 'U',
          "TRANSACTION_ID"     => '6V100HV36D98',
          "MERCHANT_ID"        => '158000',
          "SESSION_ID"         => '1',
          "RULES_TRIGGERED"    => '0',
          "COUNTERS_TRIGGERED" => '0',
          "REASON_CODE"        => nil,
          "WARNING_COUNT"      => 0
        }
      end
    end
  end
end
