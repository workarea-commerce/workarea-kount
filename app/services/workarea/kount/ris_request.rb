module Workarea
  module Kount
    class RisRequest
      attr_reader :order, :payment, :mode

      private

        def base_fields
          {
            MACK: 'Y',
            AUTH: 'A',
            SESS: order.kount_session_id,
            MODE: mode
          }
        end

        def authorization_transaction
          @authorization_transaction ||= payment
            .credit_card
            .transactions
            .authorizes
            .successful
            .first
        end

        def avs_response
          return {} unless authorization_transaction.present? && payment.uses_credit_card?

          avs_code = authorization_transaction.response.avs_result
          case avs_code
          when 'A', 'B', 'O'
            street = 'M'
            zip    = 'N'
          when 'L', 'P', 'W', 'Z'
            street = 'N'
            zip    = 'M'
          when 'C', 'I', 'K', 'N', '4'
            street = 'N'
            zip    = 'N'
          when 'D', 'M', 'H', 'V', 'X', 'Y', '3'
            street = 'M'
            zip    = 'M'
          when 'E', 'G', 'R', 'S', 'U', '1', '2'
            street = 'X'
            zip    = 'X'
          when 'F'
            street = 'X'
            zip    = 'M'
          when 'T'
            street = 'M'
            zip    = 'X'
          else
            Kount.log_error "KOUNT WARNING: Unsupported AVS Code: #{avs_code} does not have a corresponding value in Kount. Marking as Unsupported/Unavailable."
            street = 'X'
            zip    = 'X'
          end

          {
            "AVST": street,
            "AVSZ": zip
          }
        end

        def cvv_response
          return {} unless authorization_transaction.present? && payment.uses_credit_card?

          cv_code = authorization_transaction.response.cvv_result
          kount_cv_code =
            case cv_code
            when 'M'
              'M' # match
            when 'N'
              'N' # no match
            when 'D', 'I', 'P', 'S', 'U', 'X', '1', '2', '3'
              'X' # unsupported or unavailable
            else
              Kount.log_error "KOUNT WARNING: Unsupported CV Code: #{cv_code} does not have a corresponding value in Kount. Marking as Unsupported/Unavailable."
              'X'
            end
          { CVVR: kount_cv_code }
        end
    end
  end
end
