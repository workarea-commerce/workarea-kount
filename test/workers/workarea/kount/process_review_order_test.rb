require 'test_helper'

module Workarea
  module Kount
    class ProcessReviewOrderTest < Workarea::TestCase
      include TestCase::SearchIndexing
      include TestCase::Mail

      def test_perform_when_the_order_is_declined
        checkout = create_purchasable_checkout(order: { kount_decision: :review })
        order = checkout.order
        _kount_order = Kount::Order.create(id: order.id)
        checkout.handle_kount_review

        ProcessReviewOrder.new.perform(order.id, false, event_string)

        order.reload
        refute(order.placed_at.present?)
        assert(order.canceled_at.present?)

        cancelation_email = ActionMailer::Base.deliveries.last
        assert_equal(
          t('workarea.storefront.email.hold_denial.subject', order_id: order.id),
          cancelation_email.subject
        )
        assert_match(
          t('workarea.storefront.email.hold_denial.info_html'),
          cancelation_email.html_part.to_s
        )
      end

      def test_perform_when_the_order_is_approved_but_payment_is_declined
        checkout = create_purchasable_checkout(order: { kount_decision: :review })
        order = checkout.order

        _kount_order = Kount::Order.create(id: order.id)
        checkout.handle_kount_review

        Workarea.config.gateways.credit_card.expects(:authorize).returns(
          ActiveMerchant::Billing::Response.new(
            false,
            ActiveMerchant::Billing::BogusGateway::FAILURE_MESSAGE,
            {
              paid_amount: 1.to_m.cents,
              error: ActiveMerchant::Billing::BogusGateway::FAILURE_MESSAGE
            },
            { test: true,
            error_code: ActiveMerchant::Billing::BogusGateway::STANDARD_ERROR_CODE[:processing_error] }
          )
        )

        ProcessReviewOrder.new.perform(order.id, true, event_string)

        order.reload
        refute(order.placed_at.present?)
        assert(order.canceled_at.present?)
        assert_equal(1, order.comments.length)

        cancelation_email = ActionMailer::Base.deliveries.last
        assert_equal(
          t('workarea.storefront.email.hold_denial.subject', order_id: order.id),
          cancelation_email.subject
        )
        assert_match(
          t('workarea.storefront.email.hold_denial.info_html'),
          cancelation_email.html_part.to_s
        )
      end

      def test_perform_when_the_order_is_approved_and_payment_is_successful
        checkout = create_purchasable_checkout(order: { kount_decision: :review })
        order = checkout.order
        _kount_order = Kount::Order.create(id: order.id)
        checkout.handle_kount_review

        ProcessReviewOrder.new.perform(order.id, true, event_string)

        order.reload
        refute(order.canceled_at.present?)
        assert(order.placed_at.present?)

        confirmation_email = ActionMailer::Base.deliveries.last
        assert_equal(
          t('workarea.storefront.email.order_confirmation.subject', order_id: order.id),
          confirmation_email.subject
        )
        assert_match(
          t('workarea.storefront.email.order_confirmation.heading', order_id: order.id),
          confirmation_email.html_part.to_s
        )
      end

      private

        def event_string
          "<event><name>WORKFLOW_STATUS_EDIT</name><key order_number=\"D58470FCF0\" site=\"DEFAULT\">7JG1075ML345</key><old_value>R</old_value><new_value>A</new_value><agent>SYSTEM@KOUNT.NET</agent><occurred>2018-05-18 06:47:47.413756</occurred></event>"
        end
    end
  end
end
