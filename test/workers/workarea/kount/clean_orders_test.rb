require 'test_helper'

module Workarea
  module Kount
    class CleanOrdersTest < TestCase
      include SearchIndexing

      def test_perform_with_review_orders
        checkout = create_purchasable_checkout(order: { kount_decision: :review, checkout_started_at: 1.year.ago })
        order = checkout.order
        order.update_attributes(updated_at: 1.year.ago)

        _kount_order = Kount::Order.create(id: order.id)
        checkout.handle_kount_review

        CleanOrders.new.perform

        orders = Workarea::Order.unscoped.all.to_a
        assert_includes orders, order
      end

      def test_perform_with_kount_declined_orders
        checkout = create_purchasable_checkout(order: { kount_decision: :review, checkout_started_at: 1.year.ago })
        order = checkout.order

        _kount_order = Kount::Order.create(id: order.id)
        checkout.handle_kount_review

        event_string = "<event><name>WORKFLOW_STATUS_EDIT</name><key order_number=\"D58470FCF0\" site=\"DEFAULT\">7JG1075ML345</key><old_value>R</old_value><new_value>A</new_value><agent>SYSTEM@KOUNT.NET</agent><occurred>2018-05-18 06:47:47.413756</occurred></event>"
        ProcessReviewOrder.new.perform(order.id, false, event_string)
        order.reload.update_attributes(updated_at: 1.year.ago)

        CleanOrders.new.perform

        orders = Workarea::Order.unscoped.all.to_a
        assert_includes orders, order
      end
    end
  end
end
