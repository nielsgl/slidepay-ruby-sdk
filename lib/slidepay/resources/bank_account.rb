module SlidePay
  class BankAccount < ApiResource
    def initialize(values_hash={})
      @url_root = "bank_account"
      @id_attribute = "bank_account_id"

      super(values_hash)
    end

  end
end
