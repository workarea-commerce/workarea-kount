module Workarea
  module Kount
    class Address
      attr_reader :prefix
      # @param Workarea::Address
      #
      # @return [Hash]
      #
      def self.for_shipping(address)
        new('S', address).to_hash
      end

      # @param Workarea::Address
      #
      # @return [Hash]
      #
      def self.for_billing(address)
        new('B', address).to_hash
      end

      def initialize(prefix, address)
        @prefix = prefix
        @address = address
      end

      def to_hash
        {
          :"#{prefix}2A1" => @address.street,
          :"#{prefix}2A2" => @address.street_2,
          :"#{prefix}2CI" => @address.city,
          :"#{prefix}2ST" => @address.region,
          :"#{prefix}2PC" => @address.postal_code,
          :"#{prefix}2CC" => @address.country.gec,
          :"#{prefix}2PN" => @address.phone_number
        }
      end
    end
  end
end
