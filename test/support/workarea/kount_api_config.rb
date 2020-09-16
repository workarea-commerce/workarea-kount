module Workarea
  module KountApiConfig
    def self.included(test)
      super
      test.setup :set_kount_credentials
      test.teardown :reset_kount_credentials
    end

    private

      def set_kount_credentials
        @_old_credentials = Workarea::Kount.credentials

        Rails.application.secrets.kount = {
          merchant_id: '200755',
          version: '0630',
          key: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIyMDA3NTUiLCJhdWQiOiJLb3VudC4xIiwiaWF0IjoxNTAwNDA3NTE1LCJzY3AiOnsia2EiOm51bGwsImtjIjpudWxsLCJhcGkiOnRydWUsInJpcyI6dHJ1ZX19.1YwTR1G8qBQ_TDK8MBYxDB2EhpUD0IlwWdvqHVOnm0o',
          ksalt: '4077th hawkeye trapper radar section-8',
          is_test: true
        }
      end

      def reset_kount_credentials
        Rails.application.secrets.kount = @_old_credentials
      end
  end
end
