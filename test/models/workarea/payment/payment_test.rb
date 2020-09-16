require 'test_helper'

module Workarea
  class PaymentIntegrationTest < Workarea::TestCase
    def test_set_credit_card_sets_the_credit_card_on_the_order
      payment.set_credit_card(number: '1',
                            month:  1,
                            year:   2012,
                            cvv:    999)

      refute_nil(payment.credit_card)

      assert_equal('1', payment.credit_card.number)
      assert_equal(1, payment.credit_card.month)
      assert_equal(2012, payment.credit_card.year)
      assert_equal(999, payment.credit_card.cvv)
    end

    def test_set_credit_card_resets_saved_card_id_on_the_credit_card_when_resetting
      card = create_saved_credit_card(profile: profile)
      card_id = card.id

      payment.set_credit_card(saved_card_id: card_id, cvv: '999')
      assert_equal(card_id.to_s, payment.credit_card.saved_card_id.to_s)
      assert_equal('999', payment.credit_card.cvv)

      payment.set_credit_card(
        number: '1',
        month: 1,
        year: 2012,
        cvv: 999
      )

      assert_equal('1', payment.credit_card.number)
      assert_equal(1, payment.credit_card.month)
      assert_equal(2012, payment.credit_card.year)
      assert(payment.credit_card.saved_card_id.blank?)
      assert_equal(999, payment.credit_card.cvv)
    end

    def test_set_credit_card_stores_kount_number
      travel_to Time.zone.local(2017, 8, 15, 9, 00, 00)
      profile = create_payment_profile
      payment = create_payment(profile: profile, address: address)

      payment.set_credit_card(
        number: '4111111111111111',
        month: 1,
        year: Time.now.year + 1,
        cvv: '123',
        amount: 1.to_m,
        saved_card_id: nil
      )
      payment.save
      payment.tenders.first.save

      payment.reload
      assert_equal('41111193FBKM1EIVIXVP', payment.credit_card.kount_number)
      travel_back
    end

    def test_set_credit_card_stores_kount_number_from_saved_credit_card
      travel_to Time.zone.local(2017, 8, 15, 9, 00, 00)
      profile = create_payment_profile(email: 'user@workarea.com')
      payment = create_payment(profile: profile, address: address)

      saved_card = create_saved_credit_card(
        number: '4111111111111111',
        profile: profile
      )

      payment.set_credit_card(
        saved_card_id: saved_card.id,
        amount: 1.to_m
      )

      payment.save!
      payment.tenders.first.save

      payment.reload
      assert_equal('41111193FBKM1EIVIXVP', payment.credit_card.kount_number)
      travel_back
    end

    def address
      @address ||= Workarea::Address.new(
        first_name: 'Mickey',
        last_name: 'Daltono',
        street: '22 S. 3rd St.',
        city: 'Philadelphia',
        region: 'PA',
        postal_code: '19106',
        country: 'US',
        phone_number: '267-247-2541'
      )
    end

    def profile
      @profile ||= create_payment_profile
    end

    def payment
      @payment ||= create_payment(profile: profile)
    end
  end
end
