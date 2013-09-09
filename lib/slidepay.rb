require "slidepay/version"
require "slidepay/client"

module SlidePay
  SUPERVISOR_URL = 'https://supervisor.getcube.com:65532/rest.svc/API/'
  PROD_API_URL = 'https://api.getcube.com:65532/rest.svc/API/'
  DEV_API_URL = 'https://dev.getcube.com:65532/rest.svc/API/'
  USE_PROXY = false
  PROXY_URI = '127.0.0.1:8888'
  DEBUG = false

  @token = nil
  @api_key = nil

  def token=(token)
    @token = token
  end

  def api_key=(api_key)
    @api_key = api_key
  end

  class << self
    def set_auth_option(auth)
      options = {}
      if auth[:token]
        options["x-cube-token"] = auth[:token]
      elsif auth[:api_key]
        options["x-cube-api_key"] = auth[:api_key]
      elsif @token
        options["x-cube-token"] = @token
      elsif @api_key
        options["x-cube-api_key"] = @api_key
      end

      options
    end

    def request(request_options_hash)
      set_auth_option request_options_hash[:auth]

      # type, path, data, auth={}, options={}

    end

    def get(request_options_hash)
    end

    def post(request_options_hash)
    end

    def put(request_options_hash)
    end

    def delete(request_options_hash)
    end
  end
end
