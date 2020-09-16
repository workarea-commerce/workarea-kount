module Workarea
  module Storefront
    class OrderMailerPreview < ActionMailer::Preview
      def hold_denial
        order = Order.where(kount_decision: :declined).first
        OrderMailer.hold_denial(order.id)
      end
    end
  end
end
