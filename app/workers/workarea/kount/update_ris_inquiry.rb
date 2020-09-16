module Workarea
  module Kount
    class UpdateRisInquiry
      include Sidekiq::Worker
      include Sidekiq::CallbacksWorker

      self.inlined = true
      sidekiq_options(
        enqueue_on: { Workarea::Payment::Transaction => :save },
        queue: 'high'
      )

      def perform(transaction_id)
        transaction = Workarea::Payment::Transaction.find(transaction_id)
        payment     = transaction.payment
        order       = Workarea::Order.find(payment.id)
        kount_order = Kount::Order.find(payment.id) rescue nil

        return unless kount_order.present? && payment.credit_card? && transaction.authorize?

        Workarea::Kount::OrderFraudUpdateService.new(
          order: order,
          payment: payment,
          options: {
            payment_transaction: transaction
          }
        ).perform!
      end
    end
  end
end
