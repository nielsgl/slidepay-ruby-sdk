require "slidepay/version"
require "rest_client"

module SlidePay
  SUPERVISOR_URL = 'https://supervisor.getcube.com:65532/rest.svc/API/'
  PROD_API_URL = 'https://api.getcube.com:65532/rest.svc/API/'
  DEV_API_URL = 'https://dev.getcube.com:65532/rest.svc/API/'
  USE_PROXY = false
  PROXY_URI = '127.0.0.1:8888'
  DEBUG = false

  class << self
    attr_accessor :token, :api_key, :endpoint

    def get_endpoint_option(options)
      if options[:endpoint]
        options[:endpoint]
      else
        @endpoint
      end
    end

    def get_auth_option(request_options_hash)
      options = {}
      if request_options_hash[:token]
        options["x-cube-token"] = request_options_hash[:token]
      elsif request_options_hash[:api_key]
        options["x-cube-api-key"] = request_options_hash[:api_key]
      elsif @token
        options["x-cube-token"] = @token
      elsif @api_key
        options["x-cube-api-key"] = @api_key
      end

      options
    end

    def request(type, request_options_hash)
      options = { "Content-Type" => "application/json" }
      options.merge! get_auth_option request_options_hash

      if request_options_hash[:email]
        options["x-cube-email"] = request_options_hash[:email]
      end

      if request_options_hash[:password]
        options["x-cube-password"] = request_options_hash[:password]
      end

      url = "#{get_endpoint_option(request_options_hash)}/#{request_options_hash[:path]}"
      data = request_options_hash[:data]

      # type, path, data, auth={}, options={}
      begin
        case type
        when "GET"
          response = RestClient.get url, options
        when "PUT"
          response = RestClient.post url, data, options
        when "POST"
          response = RestClient.put url, data, options
        when "DELETE"
          response = RestClient.delete url, options
        else
          raise Exception.new("Invalid request type specified")
        end
      rescue => e
        raise Exception.new("Request to #{url} failed with status code: #{e}")
      end
    end

    def get(request_options_hash)
      if request_options_hash.is_a? String
        request_options_hash = { :path => request_options_hash }
      end

      request("GET", request_options_hash)
    end

    def post(request_options_hash)
      request("POST", request_options_hash)
    end

    def put(request_options_hash)
      request("PUT", request_options_hash)
    end

    def delete(request_options_hash)
      if request_options_hash.is_a? String
        request_options_hash = { :path => request_options_hash }
      end

      request("DELETE", request_options_hash)
    end

    def configure
      if @endpoint == nil
        @endpoint = SUPERVISOR_URL
      end
    end

    # configure
  end
end
