module Workarea
  class Payment
    module Status
      class KountReview
        include StatusCalculator::Status

        def in_status?
          Workarea::Order.find(@model.id).under_review?
        end
      end
    end
  end
end
