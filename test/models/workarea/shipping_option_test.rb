require 'test_helper'

module Workarea
  class ShippingOptionTest < TestCase
    def order
      @order ||= Order.create!(email: 'user@workarea.com')
    end

    def shipping_service
      @shipping_service ||= create_shipping_service(
        id: '123',
        name: 'Standard Shipping',
        tax_code: '001',
        rates: [{ price: 7.to_m }],
        kount_code: 'ST'
      )
    end

    def shipment
      @shipment ||= Workarea::Shipping.create!(order_id: order.id).tap { |shipment|
        shipment.shipping_service = shipping_service
      }
    end

    def test_valid_returns_true_if_a_shipments_shipping_service_contains_a_kount_code
      assert_equal(shipment.shipping_service.kount_code, 'ST')
    end
  end
end
