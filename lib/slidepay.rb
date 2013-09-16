# Dependencies
require "rest-client"
require "multi_json"
require "json"

# SlidePay Modules and
require "slidepay/version"
require "slidepay/config"
require "slidepay/response"

# Instance-Level API Interaction
require "slidepay/client"

# CRUD Capable Resources
require "slidepay/resources/api_resource"
require "slidepay/resources/api_key"
require "slidepay/resources/payment"

module SlidePay
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

    def authenticate(email, password)
      response = retrieve_token(email, password)
      if response.was_successful?
        @token = response.data
        true
      else
        false
      end
    end

    def retrieve_token(email, password)
      get(path: "login", :email => email, :password => password)
    end

    def retrieve_endpoint(email)
      get(path: "endpoint", :email => email)
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

      url = "#{get_endpoint_option(request_options_hash)}#{request_options_hash[:path]}"
      data = request_options_hash[:data]

      begin
        case type
        when "GET"
          response = RestClient.get url, options
        when "PUT"
          response = RestClient.put url, data, options
        when "POST"
          response = RestClient.post url, data, options
        when "DELETE"
          response = RestClient.delete url, options
        else
          raise Exception.new("Invalid request type specified")
        end
      rescue => e
        # raise Exception.new("Request to #{url} failed with status code: #{e}")
        response = e.response
      end

      Response.new(response)
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

    def configure(options_hash={})
      if options_hash[:api_key]
        @api_key = options_hash[:api_key]
      end

      if options_hash[:token]
        @token = options_hash[:token]
      end

      if options_hash[:endpoint]
        @endpoint = options_hash[:endpoint]
      elsif options_hash[:development] == true
        @endpoint = DEV_API_URL
      else
        @endpoint = SUPERVISOR_URL
      end
    end
  end

  self.configure
end
