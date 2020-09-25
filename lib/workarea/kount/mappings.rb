module Workarea
  module Kount
    class Mappings
      MAPPING = {
        # REQUEST INFO
        version: 'VERS',
        mode: 'MODE',
        sdk: 'SDK',
        merchant_id: 'MERC',
        session_id: 'SESS',
        merchant_order_number: 'ORDR',
        site: 'SITE',
        format: 'FRMT',
        transaction_id: 'TRAN',

        # MONEY
        currency: 'CURR',
        total: 'TOTL',
        cash: 'CASH',

        # USER INFO
        phone_number: 'ANID',
        email: 'EMAL',
        customer_name: 'NAME',
        dob: 'DOB',
        gender: 'GENDER',

        ship_to_name: 'S2NM',
        ship_to_email: 'S2EM',

        # SHIPPING ADDRESS
        ship_to_address1: 'S2A1',
        ship_to_address2: 'S2A2',
        ship_to_city: 'S2CI',
        ship_to_state: 'S2ST',
        ship_to_postal: 'S2PC',
        ship_to_country_code: 'S2CC',
        ship_to_phone_number: 'S2PN',

        # BILLING ADDRESS
        bill_to_address1: 'B2A1',
        bill_to_address2: 'B2A2',
        bill_to_city: 'B2CI',
        bill_to_state: 'B2ST',
        bill_to_postal: 'B2PC',
        bill_to_country_code: 'B2CC',
        bill_to_phone_number: 'B2PN',

        bill_to_premises: 'BPREMISE', # UK
        bill_to_street: 'BSTREET', # UK
        ship_to_premises: 'SPREMISE', # UK
        ship_to_street: 'SSTREET', # UK

        # PAYMENT
        payment_type: 'PTYP',
        payment_data: 'PTOK',
        payment_encoding: 'PENC', # KASH

        driver_license_number: 'DRIV',
        customer_id: 'UNIQ',
        customer_created_at: 'EPOC', # EPOC when user was created
        ip_address: 'IPAD',
        http_user_agent: 'UAGT',
        shipping_type: 'SHPT',

        # ORDER STATUS CODES
        merchant_ack: 'MACK',
        authorization_status: 'AUTH',
        avs_zip_response: 'AVSZ',
        avs_street_response: 'AVST',
        cvv_response: 'CVVR',
        refund_charge_back_status: 'RFCB'
      }.freeze

      AUTO_MAPPING = {
        'D' => :declined,
        'R' => :review,
        'E' => :manager_review,
        'A' => :approved
      }.freeze

      # Public: A hash that maps Kount response key names to readable Ruby symbols
      RESPONSE_MAPPING = {
        "VELO":               :velocity,
        "REGION":             :region,
        "FLASH":              :flash,
        "TRAN":               :transaction_id,
        "DEVICE_LAYERS":      :device_layers,
        "JAVASCRIPT":         :javascript,
        "HTTP_COUNTRY":       :http_country,
        "MODE":               :mode,
        "EMAILS":             :emails,
        "TIMEZONE":           :timezone,
        "MOBILE_TYPE":        :mobile_type,
        "WARNING_COUNT":      :warning_count,
        "REGN":               :region,
        "LOCALTIME":          :localtime,
        "COUNTRY":            :country,
        "REAS":               :reason_variable,
        "CARDS":              :cards,
        "PROXY":              :proxy,
        "VOICE_DEVICE":       :voice_device,
        "BRND":               :payment_brand,
        "NETW":               :network,
        "KAPT":               :has_ris_record,
        "FINGERPRINT":        :fingerprint,
        "COOKIES":            :cookies,
        "LANGUAGE":           :language,
        "RULES_TRIGGERED":    :rules_triggered,
        "SESS":               :session_id,
        "GEOX":               :worst_contry_associated,
        "DEVICES":            :devices,
        "VMAX":               :vmax,
        "SITE":               :site,
        "ORDR":               :order_id,
        "AUTO":               :auto,
        "SCOR":               :score,
        "COUNTERS_TRIGGERED": :counters_triggered,
        "VERS":               :version,
        "MERC":               :merchant_id,
        "PC_REMOTE":          :pc_remote,
        "MOBILE_DEVICE":      :mobile_device,
        "MOBILE_FORWARDER":   :mobile_forwarder,
        "KYCF":               :know_your_customer,
        "ERROR_COUNT":        :error_count,
        "ERRO":               :error
      }.freeze

      # Public: A hash that maps Kount Error Numbers to Error Codes
      ERRORS = {
        '201': 'MISSING_VERS',
        '202': 'MISSING_MODE',
        '203': 'MISSING_MERC',
        '204': 'MISSING_SESS',
        '205': 'MISSING_TRAN',
        '211': 'MISSING_CURR',
        '212': 'MISSING_TOTL',
        '221': 'MISSING_EMAL',
        '222': 'MISSING_ANID',
        '223': 'MISSING_SITE',
        '231': 'MISSING_PTYP',
        '232': 'MISSING_CARD',
        '233': 'MISSING_MICR',
        '234': 'MISSING_PYPL',
        '235': 'MISSING_PTOK',
        '241': 'MISSING_IPAD',
        '251': 'MISSING_MACK',
        '261': 'MISSING_POST',
        '271': 'MISSING_PROD_TYPE',
        '272': 'MISSING_PROD_ITEM',
        '273': 'MISSING_PROD_DESC',
        '274': 'MISSING_PROD_QUANT',
        '275': 'MISSING_PROD_PRICE',
        '301': 'BAD_VERS',
        '302': 'BAD_MODE',
        '303': 'BAD_MERC',
        '304': 'BAD_SESS',
        '305': 'BAD_TRAN',
        '311': 'BAD_CURR',
        '312': 'BAD_TOTL',
        '321': 'BAD_EMAL',
        '322': 'BAD_ANID',
        '323': 'BAD_SITE',
        '324': 'BAD_FRMT',
        '331': 'BAD_PTYP',
        '332': 'BAD_CARD',
        '333': 'BAD_MICR',
        '334': 'BAD_PYPL',
        '335': 'BAD_GOOG',
        '336': 'BAD_BLML',
        '337': 'BAD_PENC',
        '341': 'BAD_IPAD',
        '351': 'BAD_MACK',
        '362': 'BAD_CART',
        '371': 'BAD_PROD_TYPE',
        '372': 'BAD_PROD_ITEM',
        '373': 'BAD_PROD_DESC',
        '374': 'BAD_PROD_QUANT',
        '375': 'BAD_PROD_PRICE',
        '399': 'BAD_OPTN',
        '401': 'EXTRA_DATA',
        '402': 'MISMATCH_PTYP',
        '403': 'UNNECESSARY_ANID',
        '404': 'UNNECESSARY_PTOK',
        '501': 'UNAUTH_REQ',
        '502': 'UNAUTH_MERC',
        '503': 'UNAUTH_IP',
        '504': 'UNAUTH_PASS',
        '601': 'SYS_ERR',
        '602': 'SYS_NOPROCESS',
        '701': 'NO_HDR'
      }.freeze
    end
  end
end
