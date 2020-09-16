require 'workarea/kount/engine'
require 'workarea/kount/version'

require 'rest_client'
require 'digest/sha1'
require 'workarea/kount/address'
require 'workarea/kount/bogus_gateway'
require 'workarea/kount/errors'
require 'workarea/kount/gateway'
require 'workarea/kount/mappings'
require 'workarea/kount/response'
require 'workarea/kount/user_defined_fields'
require 'workarea/kount/payment_types'
require 'workarea/kount/security_mash'


module Workarea
  module Kount
    def self.config
      Workarea.config.kount
    end

    def self.enabled?
      !!config.enabled
    end

    def self.credentials
      (Rails.application.secrets.kount || {}).deep_symbolize_keys
    end

    def self.ksalt
      credentials[:ksalt]
    end

    def self.merchant_id
      credentials[:merchant_id]
    end

    def self.key
      credentials[:key]
    end

    def self.kount_site
      credentials[:kount_site] || 'DEFAULT'
    end

    def self.kount_api_version
      credentials[:version]
    end

    def self.data_collector_url
      return config[:data_collector_url] if config[:data_collector_url].present?

      if Rails.env.production?
        'https://ssl.kaptcha.com/'
      else
        'https://tst.kaptcha.com/'
      end
    end

    def self.kount_order_url_base
      if credentials.fetch(:is_test, false)
        "https://awc.test.kount.net/workflow/detail.html?id="
      else
        "https://awc.kount.net/workflow/detail.html?id="
      end
    end

    def self.gateway
      if credentials.present?
        Workarea::Kount::Gateway.new(
          credentials.slice(:merchant_id, :version, :key, :ksalt, :is_test)
        )
      else
        Workarea::Kount::BogusGateway.new
      end
    end

    def self.log_error(error)
      if defined?(::Raven)
        Raven.capture_exception error
      else
        Rails.logger.warn error
      end
    end
  end
end
