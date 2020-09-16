require 'test_helper'

module Workarea
  module Kount
    class SecurityMashTest < Workarea::TestCase
      def test_hash_token
        fixture_cards = [
          ["7103387671500967", "710338010UCJ25C9JLKG"],
          ["5199185454061655", "5199182QMVHKQ9X56M9X"],
          ["4259344583883",    "425934CG9C5L4J9JU6W3"],
          ["6495347478600780", "649534VVS6JHO5CDQFIW"],
          ["4990160432687370", "499016QLDL0OP3SMX0MT"],
          ["2630847576846156", "263084CARRC9W3XDLS8R"]
        ]

        fixture_cards.each do |(card, hashed)|
          assert_equal(
            hashed,
            Kount::SecurityMash.hash_token(card, 'CARD', ksalt)
          )
        end
      end

      def test_hash_token_when_already_hashed
        fixture_cards = [
          ["499016QLDL0OP3SMX0MT", "499016QLDL0OP3SMX0MT"],
          ["425934CG9C5L4J9JU6W3", "425934CG9C5L4J9JU6W3"],
          ["710338010UCJ25C9JLKG", "710338010UCJ25C9JLKG"]
        ]

        fixture_cards.each do |(card, hashed)|
          assert_equal(
            hashed,
            Kount::SecurityMash.hash_token(card, 'CARD', ksalt)
          )
        end
      end

      def test_hash_gift_card
        merchant_id = '555555'
        fixture_cards = [
          ["7388460E9D",        "555555UF1IG4DV7HRWN3"],
          ["50906199",          "5555559JUX7H9KGJYHH8"],
          ["41658068FC266C309", "555555ZFV2XK4ELP9OMJ"]
        ]

        fixture_cards.each do |(card, hashed)|
          assert_equal(
            hashed,
            Kount::SecurityMash.hash_token(card, 'GIFT', ksalt, merchant_id)
          )
        end
      end

      private

        def ksalt
          'public-test-salt'
        end
    end
  end
end
