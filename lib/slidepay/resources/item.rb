module SlidePay
  class Item < ApiResource
    def initialize(values_hash={})
      @url_root = "api_key"
      @id_attribute = "api_key_id"

      super(values_hash)
    end
  end
end
