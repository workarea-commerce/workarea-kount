module Workarea
  class Payment
    module Status
      class KountDeclined
        include StatusCalculator::Status

        def in_status?
          Workarea::Order.find(@model.id).kount_decision == :decline
        end
      end
    end
  end
end
