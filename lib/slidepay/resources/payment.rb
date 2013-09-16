module SlidePay
  class Payment < ApiResource
    @id_attribute = "payment_id"
    @url_root = "payment"

    def save(arguments_hash)
      process(arguments_hash)
    end

    def destroy
      false
    end

    def process(arguments_hash)
      SlidePay.post(api_key: @api_key, token: @token, data: self.to_json, path: "payment/simple")
    end

    def refund(arguments_hash)
      SlidePay.post(api_key: @api_key, token: @token, data: self.to_json, path: "payment/refund")
    end
  end
end