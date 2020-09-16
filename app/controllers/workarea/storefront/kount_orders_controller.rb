module Workarea
  module Storefront
    class KountOrdersController < ApplicationController
      skip_before_action :verify_authenticity_token, only: [:bulk]
      before_action :authenticate

      def bulk
        event_batch = Kount::EventBatch.new(request.raw_post)

        if event_batch.valid?
          event_batch.process!
          successful_response
        else
          unsuccessful_response
        end
      end

      private

        def authenticate
          authenticated = authenticate_with_http_basic do |username, password|
            Kount.credentials[:ens_username].present? &&
              Kount.credentials[:ens_password].present? &&
              username == Kount.credentials[:ens_username] &&
              password == Kount.credentials[:ens_password]
          end

          unsuccessful_response unless authenticated
        end

        def successful_response
          render json: { status: 200 }
        end

        def unsuccessful_response
          head :bad_request
        end
    end
  end
end
