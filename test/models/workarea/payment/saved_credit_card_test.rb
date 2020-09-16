require 'test_helper'

module Workarea
  module Storefront
    class SavedCreditCardTest < Workarea::TestCase
      def test_saving_credit_card_stores_kount_number_for_saved_credit_card
        travel_to Time.zone.local(2017, 8, 15, 9, 00, 00)

        saved_card = Workarea::Payment::SavedCreditCard.create(
          profile: create_payment_profile(email: 'user@workarea.com'),
          first_name: 'Ben',
          last_name: 'Crouse',
          number: '4111111111111111',
          month: 1,
          year: Time.now.year + 1,
          cvv: '999'
        )

        assert_equal('41111193FBKM1EIVIXVP', saved_card.kount_number)
        travel_back
      end
    end
  end
end
