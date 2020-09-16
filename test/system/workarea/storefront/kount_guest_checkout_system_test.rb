require 'test_helper'

module Workarea
  module Storefront
    class KountGuestCheckoutSystemTest < Workarea::SystemTest
      include Storefront::SystemTest

      setup :setup_checkout_specs
      setup :start_guest_checkout

      def test_fraud_payment_failure
        assert_current_path(storefront.checkout_addresses_path)
        fill_in 'email', with: 'decline@workarea.com'
        fill_in_shipping_address
        uncheck 'same_as_shipping'
        fill_in_billing_address
        click_button t('workarea.storefront.checkouts.continue_to_shipping')

        assert_current_path(storefront.checkout_shipping_path)
        click_button t('workarea.storefront.checkouts.continue_to_payment')

        assert_current_path(storefront.checkout_payment_path)
        fill_in_credit_card
        fill_in 'credit_card[number]', with: '1'
        click_button t('workarea.storefront.checkouts.place_order')

        assert_current_path(storefront.checkout_place_order_path)
        assert(page.has_content?('Error'))
      end
    end
  end
end
