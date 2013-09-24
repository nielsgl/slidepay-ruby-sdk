module SlidePay
  class ApiResource < Hash
    attr_accessor :url_root, :id_attribute, :token, :api_key, :endpoint

    def initialize(values_hash={})
      if values_hash[:url_root]
        @url_root = values_hash[:url_root]
        values_hash.delete(:url_root)
      end

      if values_hash[:id_attribute]
        @id_attribute = values_hash[:id_attribute]
        values_hash.delete(:id_attribute)
      end

      if values_hash[:token]
        @token = values_hash[:token]
        values_hash.delete(:token)
      end

      if values_hash[:api_key]
        @api_key = values_hash[:api_key]
        values_hash.delete(:api_key)
      end

      if values_hash[:endpoint]
        @endpoint = values_hash[:endpoint]
        values_hash.delete(:endpoint)
      end

      merge! values_hash
    end

    def url
      if is_new?
        @url_root
      else
        "#{@url_root}/#{self.id()}"
      end
    end

    def id
      self[@id_attribute]
    end

    def is_new?
      if id() == nil
        true
      else
        false
      end
    end

    def populate_from_response(response)
      if response.data.instance_of? Array
        self.merge! response.data.first
      elsif response.data.instance_of? Hash
        self.merge! response.data
      else
        raise Exception.new("Resource with the specified id not found on the server.")
      end
    end

    def retrieve(options_hash={})
      token = @token || options_hash[:token]
      api_key = @api_key || options_hash[:api_key]
      endpoint = @endpoint || options_hash[:endpoint]

      if is_new?
        raise Exception.new("Cannot retrieve an unsaved object from the server.")
      end

      response = SlidePay.get(path: self.url(), token: token, api_key: api_key, endpoint: endpoint)
      if response.was_successful?
        self.populate_from_response(response)
      end
    end

    def save(options_hash={})
      token = @token || options_hash[:token]
      api_key = @api_key || options_hash[:api_key]
      endpoint = @endpoint || options_hash[:endpoint]

      if is_new?
        response = SlidePay.post(path: self.url(), token: token, api_key: api_key, endpoint: endpoint, data: self.to_json)
      else
        response = SlidePay.put(path: self.url(), token: token, api_key: api_key, endpoint: endpoint, data: self.to_json)
      end

      if response.was_successful?
        self.populate_from_response(response)
        true
      else
        false
      end
    end

    def destroy(options_hash={})
      token = @token || options_hash[:token]
      api_key = @api_key || options_hash[:api_key]
      endpoint = @endpoint || options_hash[:endpoint]

      if is_new?
        raise Exception.new("Cannot destroy a resource that has not been saved.")
      end

      response = SlidePay.delete(path: self.url(), token: token, api_key: api_key, endpoint: endpoint)

      if response.was_successful?
        self[@id_attribute] = nil
        true
      else
        false
      end
    end
  end
end
