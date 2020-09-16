Workarea.configure do |config|
  config.order_status_calculators.insert(0, 'Workarea::Order::Status::Review')

  config.kount ||= ActiveSupport::Configurable::Configuration.new

  config.kount.enabled = true

  config.payment_status_calculators.insert_before(
    "Workarea::Payment::Status::NotApplicable",
    "Workarea::Payment::Status::KountDeclined"
  )

  config.payment_status_calculators.insert_after(
    "Workarea::Payment::Status::NotApplicable",
    "Workarea::Payment::Status::KountReview"
  )

  config.status_state_indicators = config.status_state_indicators.merge(
    kount_review: 'pending',
    kount_declined: 'danger',
  )
end
