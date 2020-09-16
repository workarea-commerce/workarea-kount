module Workarea
  module Kount
    class Order
      include ApplicationDocument

      field :response,        type: Workarea::Kount::Response
      field :update_response, type: Workarea::Kount::Response

      embeds_many :ens_events, class_name: 'Workarea::Kount::EnsEvent'

      index(created_at: -1)
    end
  end
end
