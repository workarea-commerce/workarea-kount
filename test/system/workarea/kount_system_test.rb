require 'test_helper'

module Workarea
  class KountSystemTest < Workarea::SystemTest
    include Admin::IntegrationTest

    def test_review_orders_are_index_in_admin_search
      checkout = create_purchasable_checkout

      checkout.order.update_attributes!(kount_decision: :review)
      assert(checkout.handle_kount_review)

      visit admin.root_path
      fill_in 'q', with: checkout.order.id
      click_button 'search_admin'

      assert page.has_content? checkout.order.id
    end

    def test_decline_orders_are_index_in_admin_search
      checkout = create_purchasable_checkout

      checkout.order.update_attributes!(kount_decision: :decline)

      visit admin.root_path
      fill_in 'q', with: checkout.order.id
      click_button 'search_admin'

      assert page.has_content? checkout.order.id
    end

    def test_review_order_payments_have_kount_review_state
      checkout = create_purchasable_checkout

      checkout.order.update_attributes!(kount_decision: :review)
      assert(checkout.handle_kount_review)

      visit admin.order_path checkout.order

      refute page.has_content? 'Pending'
      assert page.has_content? 'Kount Review'
    end

    def test_decline_order_payments_have_kount_declined_state
      checkout = create_purchasable_checkout

      checkout.order.update_attributes!(kount_decision: :decline)

      visit admin.order_path checkout.order

      refute page.has_content? 'Pending'
      assert page.has_content? 'Kount Declined'
    end

    def test_viewing_order_kount_card
      checkout = create_purchasable_checkout

      _kount_order = create_kount_order(id: checkout.order.id)

      checkout.order.update_attributes!(kount_decision: :approve)
      assert(checkout.place_order)

      visit admin.kount_order_path checkout.order

      assert page.has_content? t('workarea.admin.orders.cards.kount.decision')
      assert page.has_content? t('workarea.admin.orders.cards.kount.score')
      assert page.has_content? t('workarea.admin.orders.cards.kount.credit_cards')
      assert page.has_content? t('workarea.admin.orders.cards.kount.email_addresses')
      assert page.has_content? t('workarea.admin.orders.cards.kount.devices')
    end
  end
end
