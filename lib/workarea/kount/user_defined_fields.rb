module Workarea
  module Kount
    class UserDefinedFields
      attr_reader :order, :user, :payment, :shipping, :shippings, :request_specific_user_defined_fields

      def initialize(checkout, request_specific_user_defined_fields = {})
        @checkout = checkout
        @request_specific_user_defined_fields = request_specific_user_defined_fields
      end

      def fields
        request_specific_user_defined_fields
      end
    end
  end
end
