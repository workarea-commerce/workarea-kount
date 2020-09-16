module Workarea
  module Kount
    class EnsEvent
      include ApplicationDocument

      field :xml, type: String

      embedded_in :kount_order,
        class_name: 'Workarea::Kount::Order',
        inverse_of: :ens_events
    end
  end
end
