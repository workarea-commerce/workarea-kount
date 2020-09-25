module Workarea
  class Order
    module Status
      class Review
        include StatusCalculator::Status

        def in_status?
          order.under_review?
        end
      end
    end
  end
end
