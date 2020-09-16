module Workarea
  module Kount
    class ProcessReviewOrder
      include Sidekiq::Worker

      sidekiq_options queue: 'high'
      attr_reader :order

      def perform(order_id, approved, event_string)
        @order = Workarea::Order.find(order_id)
        return unless order.under_review?

        Workarea::Kount::Order.find(order.id).tap do |kount_order|
          kount_order.ens_events.create!(xml: event_string)
        end

        with_order_lock do
          if approved
            order.update_attributes(kount_decision: :approve)
            place_order
          else
            order.update_attributes(kount_decision: :decline)
            cancel_order
          end
        end
      end

      private

        def with_order_lock
          order.lock!
          yield
        ensure
          order.unlock!
        end

        def checkout
          @checkout ||= Workarea::Checkout.new(order)
        end

        def place_order
          if checkout.handle_kount_approved
            place_order_side_effects
          else
            write_comment
            cancel_order
          end
        end

        def place_order_side_effects
          Workarea::Storefront::OrderMailer.confirmation(order.id).deliver_now
        end

        def write_comment
          transaction = Workarea::Payment::Transaction
            .where(payment_id: order.id)
            .order(:updated_at.desc)
            .first

          body =
            if transaction
              "Kount review order approved but payment declined: #{transaction.message}"
            else
              'Kount review order approved but failed without a payment transaction.'
            end

          order.comments.create(body: body)
        end

        def cancel_order
          Kount::CancelOrderUnderReview.new(order).cancel!
        end
    end
  end
end
