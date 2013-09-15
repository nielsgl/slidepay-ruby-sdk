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

    def is_authenticated?
      @token != nil || @api_key != nil
    end

    def authenticate(email, password)
      response = SlidePay.retrieve_token(email, password)
      puts "Authenticated with SlidePay? -- #{response}"
    end

    def retrieve(resource)
      SlidePay.get(path: resource.url(), token: @token, api_key: @api_key)
    end

    def save(resource)
      puts "Client.save called"

      if resource.is_new?
        SlidePay.post(path: resource.url(), token: @token, api_key: @api_key, data: resource.to_json())
      else
        SlidePay.put(path: resource.url(), token: @token, api_key: @api_key, data: resource.to_json())
      end
    end

    def create(resource)
      puts "Client.create called"

      SlidePay.post(path: resource.url(), token: @token, api_key: @api_key, data: resource.to_json())
    end

    def destroy
      puts "Client.destroy called"
      SlidePay.delete(path: resource.url(), token: @token, api_key: @api_key)
    end

  end
end
