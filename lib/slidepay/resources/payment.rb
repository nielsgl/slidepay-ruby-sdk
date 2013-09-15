module SlidePay
  class Payment
    @id_attribute = "payment_id"
    @path = "payment/simple"

    def process
      SlidePay.post(api_key: @api_key, token: @token, data: self.to_json, path: "payment/simple")
    end

    def refund
      SlidePay.post(api_key: @api_key, token: @token, data: self.to_json, path: "payment/refund")
    end
  end
end