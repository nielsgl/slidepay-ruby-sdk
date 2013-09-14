module SlidePay
  class Client
    attr_accessor :endpoint, :email, :password, :token, :api_key

    def initialize(options={})
      if options[:endpoint]
        @endpoint = options[:endpoint]
      end
      if options[:email]
        @email = options[:email]
      end
      if options[:password]
        @password = options[:password]
      end
      if options[:token]
        @token = options[:token]
      end
      if options[:api_key]
        @api_key = options[:api_key]
      end
    end

  end
end
