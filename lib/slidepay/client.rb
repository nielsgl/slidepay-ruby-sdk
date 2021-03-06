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
      options = {}
      if request_params.is_a? String
        options = { :path => request_params, :api_key => @api_key, :token => @token, :endpoint => @endpoint }
      else
        options.merge! api_key: @api_key, token: @token, endpoint: @endpoint
      end

      SlidePay.get(options)
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
      options = {}
      if request_params.is_a? String
        options = { :path => request_params, :api_key => @api_key, :token => @token, :endpoint => @endpoint }
      else
        options.merge! api_key: @api_key, token: @token, endpoint: @endpoint
      end
      SlidePay.delete(options)
    end


    # Resource Methods
    def list(resource)
      response = SlidePay.get(path: resource.url_root, api_key: @api_key, token: @token, endpoint: @endpoint)
      if response.was_successful?
        resources = []
        response.data.each do |resource_instance|
          resources.push resource.class.new(resource_instance)
        end
      else
        resources = []
      end

      resources
    end

    def retrieve(resource)
      resource.retrieve(api_key: @api_key, token: @token, endpoint: @endpoint)
    end

    def save(resource)
      resource.save(api_key: @api_key, token: @token, endpoint: @endpoint)
    end

    def destroy(resource)
      resource.destroy(api_key: @api_key, token: @token, endpoint: @endpoint)
    end

  end
end
