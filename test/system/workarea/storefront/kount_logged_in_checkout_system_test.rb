require 'test_helper'

module Workarea
  module Storefront
    class KountLoggedInCheckoutSystemTest < Workarea::SystemTest
      include Storefront::SystemTest

      def test_review_orders_are_still_in_cart
        # setup
        email = 'review@workarea.com'
        create_supporting_data email: email
        add_product_to_cart
        add_user_data email: email
        start_user_checkout email: email

        click_button t('workarea.storefront.checkouts.place_order')
        assert_current_path(storefront.checkout_confirmation_path)
        assert(page.has_content?('Success'))

        visit storefront.cart_path

        assert_equal(Order.first.status, :review)
        assert(page.has_no_content?('Integration Product'))
      end

      private

        def create_supporting_data(email: 'bcrouse@workarea.com')
          create_tax_category(
            name: 'Sales Tax',
            code: '001',
            rates: [{ percentage: 0.07, country: 'US', region: 'PA' }]
          )

          create_shipping_service(
            name: 'Ground',
            tax_code: '001',
            rates: [{ price: 7.to_m }]
          )

          create_inventory(id: 'SKU', policy: 'standard', available: 5)

          @product = create_product(
            id: 'INT_PRODUCT',
            name: 'Integration Product',
            variants: [{ sku: 'SKU',  tax_code: '001', regular: 5.to_m }]
          )

          create_user(email: email, password: 'W3bl1nc!')
        end

        def add_user_data(email: 'bcrouse@workarea.com')
          user = User.find_by_email email

          user.auto_save_shipping_address(
            first_name: 'Ben',
            last_name: 'Crouse',
            street: '22 S. 3rd St.',
            city: 'Philadelphia',
            region: 'PA',
            postal_code: '19106',
            country: 'US',
            phone_number: '2159251800'
          )

          user.auto_save_billing_address(
            first_name: 'Ben',
            last_name: 'Crouse',
            street: '1019 S. 47th St.',
            city: 'Philadelphia',
            region: 'PA',
            postal_code: '19143',
            country: 'US',
            phone_number: '2159251800'
          )

          profile = Payment::Profile.lookup(PaymentReference.new(user))
          profile.credit_cards.create!(
            first_name: 'Ben',
            last_name: 'Crouse',
            number: '1',
            month: 1,
            year: Time.current.year + 1,
            cvv: '999'
          )
        end

        def start_user_checkout(email: 'bcrouse@workarea.com')
          visit storefront.checkout_path
          click_link t('workarea.storefront.checkouts.login_title')

          within '#login_form' do
            fill_in 'email', with: email
            fill_in 'password', with: 'W3bl1nc!'
            click_button t('workarea.storefront.users.login')
          end
        end
    end
  end
end
