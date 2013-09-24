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

    def authenticate(email=nil, password=nil)
      email = email || @email
      password = password || @password

      response = SlidePay.retrieve_token(email, password)

      if response.was_successful?
        @token = response.data
        true
      else
        false
      end
    end

    # Base Request Methods
    def get(request_params)
      if request_params.is_a? String
        SlidePay.get(path: request_params, api_key: @api_key, token: @token, endpoint: @endpoint)
      else
        request_params.merge! api_key: @api_key, token: @token, endpoint: @endpoint
        SlidePay.get(request_params)
      end
    end

    def put(request_params)
      request_params.merge! api_key: @api_key, token: @token, endpoint: @endpoint
      SlidePay.put(request_params)
    end

    def post(request_params)
      request_params.merge! api_key: @api_key, token: @token, endpoint: @endpoint
      SlidePay.post(request_params)
    end

    def delete(request_params)
      if request_params.is_a? String
        SlidePay.delete(path: request_params, api_key: @api_key, token: @token, endpoint: @endpoint)
      else
        request_params.merge! api_key: @api_key, token: @token, endpoint: @endpoint
        SlidePay.delete(request_params)
      end
    end


    # Resource Methods
    def list(resource)
      puts "Client.list called with: #{resource}"
      SlidePay.get(path: resource.url_root, api_key: @api_key, token: @token, endpoint: @endpoint)
    end

    def retrieve(resource)
      puts "Client.retrieve called with: #{resource}"
      resource.retrieve(api_key: @api_key, token: @token, endpoint: @endpoint)
    end

    def save(resource)
      puts "Client.save called with: #{resource}"
      resource.save(api_key: @api_key, token: @token, endpoint: @endpoint)
    end

    def destroy(resource)
      puts "Client.destroy called with: #{resource}"
      resource.save(api_key: @api_key, token: @token, endpoint: @endpoint)
    end

  end
end
