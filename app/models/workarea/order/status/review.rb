module Workarea
  class Order
    module Status
      class Review
        include StatusCalculator::Status

        def in_status?
          !order.placed? && order.under_review? && !order.canceled?
        end
      end
    end
  end
end
