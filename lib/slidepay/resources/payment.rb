module SlidePay
  class Payment < ApiResource
    def initialize(values_hash={})
      @id_attribute = "payment_id"
      @url_root = "payment"

      super(values_hash)
    end

    def save(options_hash={})
      process(options_hash)
    end

    def destroy(options_hash={})
      refund(options_hash)
    end

    def process(options_hash={})
      token = @token || options_hash[:token]
      api_key = @api_key || options_hash[:api_key]
      endpoint = @endpoint || options_hash[:endpoint]

      response = SlidePay.post(path: "payment/simple", api_key: api_key, token: token, endpoint: endpoint, data: self.to_json)

      if response.was_successful?
        self["payment_id"] = response.data["payment_id"]
        self["order_master_id"] = response.data["order_master_id"]
        true
      elsif response.error_text
        raise Exception.new(response.error_text)
      elsif response.data["status_message"]
        raise Exception.new(response.data["status_message"])
      else
        raise Exception.new("Payment could not be processed.")
      end
    end

    def refund(options_hash={})
      token = @token || options_hash[:token]
      api_key = @api_key || options_hash[:api_key]
      endpoint = @endpoint || options_hash[:endpoint]

      response = SlidePay.post(path: "payment/refund/#{self.id()}", api_key: api_key, token: token, endpoint: endpoint, data: self.to_json)

      response.was_successful?
    end
  end
end