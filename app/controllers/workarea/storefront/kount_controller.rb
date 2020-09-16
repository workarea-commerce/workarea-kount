module Workarea
  module Storefront
    class KountController < Workarea::Storefront::ApplicationController
      def data_collector
        current_order.update_attributes(kount_session_id: kount_session_id)

        params = { merchant_id: Workarea::Kount.merchant_id, s: kount_session_id }

        redirect_to "#{Workarea::Kount.data_collector_url}logo.htm?#{params.to_query}", status: 302
      end

      private

        def kount_session_id
          @kount_session_id ||= "#{current_order.id}#{Time.now.to_i}R#{rand(10000..99999)}"
        end
    end
  end
end
