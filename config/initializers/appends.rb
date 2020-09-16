module Workarea
  Plugin.append_partials(
    'storefront.checkout_payment_top',
    'workarea/storefront/checkouts/kount_data_collector'
  )

  Plugin.append_partials(
    'admin.order_cards',
    'workarea/admin/orders/kount'
  )
end
