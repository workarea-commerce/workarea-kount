module Workarea
  module Factories
    module Kount
      Factories.add self

      def create_purchasable_checkout(options = {})
        product = create_product(variants: [{ sku: 'SKU', regular: 5.to_m }])

        order_attributes = {
          email: 'bcrouse-new@workarea.com'
        }.merge(options[:order] || {})

        order = Workarea::Order.new(order_attributes).tap do |o|
          o.add_item(product_id: product.id, sku: 'SKU', quantity: 2)
        end

        order.items.each do |item|
          item.update_attributes!(OrderItemDetails.find!(item.sku).to_h)
        end
        checkout = Checkout.new(order)

        shipping_address = {
          first_name: 'Ben',
          last_name: 'Crouse',
          street: '22 S. 3rd St.',
          street_2: 'Second Floor',
          city: 'Philadelphia',
          region: 'PA',
          postal_code: '19106',
          country: 'US'
        }.merge(options[:shipping_address] || {})

        billing_address = {
          first_name: 'Ben',
          last_name: 'Crouse',
          street: '22 S. 3rd St.',
          street_2: 'Second Floor',
          city: 'Philadelphia',
          region: 'PA',
          postal_code: '19106',
          country: 'US'
        }.merge(options[:billing_address] || {})

        payment = options.fetch(:payment, "new_card")

        credit_card = {
          number: '4111_1111_1111_1111',
          month: '01',
          year: Time.current.year + 1,
          cvv: '999'
        }.merge(options[:credit_card] || {})

        if payment != "new_card"
          order.save!
          card = checkout.payment_profile.credit_cards.create credit_card.merge(
            first_name: 'Eric',
            last_name: 'Pigeon'
          )
          raise 'Failed to store credit card' unless card.persisted?
          credit_card = {}
          payment = card.id.to_s
        end

        shipping_service = options[:shipping_service].presence ||
                            create_shipping_service.name


        checkout.update(
          shipping_address: shipping_address,
          billing_address: billing_address,
          shipping_service: shipping_service,
          payment: payment,
          credit_card: credit_card
        )

        checkout
      end

      def create_kount_order(options = {})
        attributes = {
          id: SecureRandom.hex(5).upcase,
          response: {
            "VERS" => "0630",
            "MODE" => "Q",
            "TRAN" => "7SSM08H1H0JG",
            "MERC" => "200755",
            "SESS" => "5F16B01A1A1543855163R26055",
            "ORDR" => "5F16B01A1A",
            "AUTO" => "A",
            "SCOR" => "34",
            "GEOX" => "US",
            "BRND" => "VISA",
            "REGN" => "US_PA",
            "NETW" => "N",
            "KAPT" => "N",
            "CARDS" => "1",
            "DEVICES" => "1",
            "EMAILS" => "1",
            "VELO" => "0",
            "VMAX" => "0",
            "SITE" => "DEFAULT",
            "DEVICE_LAYERS" => "....",
            "FINGERPRINT" => nil,
            "TIMEZONE" => nil,
            "LOCALTIME" => " ",
            "REGION" => nil,
            "COUNTRY" => nil,
            "PROXY" => nil,
            "JAVASCRIPT" => nil,
            "FLASH" => nil,
            "COOKIES" => nil,
            "HTTP_COUNTRY" => nil,
            "LANGUAGE" => nil,
            "MOBILE_DEVICE" => nil,
            "MOBILE_TYPE" => nil,
            "MOBILE_FORWARDER" => nil,
            "VOICE_DEVICE" => nil,
            "PC_REMOTE" => nil,
            "RULES_TRIGGERED" => 1,
            "RULE_ID_0" => "1326652",
            "RULE_DESCRIPTION_0" => "WEBLINC AUTO APPROVE",
            "COUNTERS_TRIGGERED" => 0,
            "REASON_CODE" => nil,
            "MASTERCARD" => "",
            "DDFS" => nil,
            "DSR" => nil,
            "UAS" => nil,
            "BROWSER" => nil,
            "OS" => nil,
            "PIP_IPAD" => nil,
            "PIP_LAT" => nil,
            "PIP_LON" => nil,
            "PIP_COUNTRY" => nil,
            "PIP_REGION" => nil,
            "PIP_CITY" => nil,
            "PIP_ORG" => nil,
            "IP_IPAD" => nil,
            "IP_LAT" => nil,
            "IP_LON" => nil,
            "IP_COUNTRY" => nil,
            "IP_REGION" => nil,
            "IP_CITY" => nil,
            "IP_ORG" => nil,
            "WARNING_COUNT" => 0
          },
          update_response: {
            "VERS" => "0630",
            "MODE" => "U",
            "TRAN" => "7SSM08H1H0JG",
            "MERC" => "200755",
            "SESS" => "5F16B01A1A1543855163R26055",
            "RULES_TRIGGERED" => 0,
            "COUNTERS_TRIGGERED" => 0,
            "REASON_CODE" => nil,
            "MASTERCARD" => "",
            "WARNING_COUNT" => 0
          }
        }.merge options

        Workarea::Kount::Order.create! attributes
      end
    end
  end
end
