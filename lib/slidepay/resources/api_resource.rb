module SlidePay
  class ApiResource < Hash
    attr_accessor :resource_name, :id_attribute, :token, :api_key, :endpoint

    def url
      if is_new?
        @resource_name
      else
        "#{@resource_name}/#{self.id()}"
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
      if response.instance_of? Array
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

      response = SlidePay.get(path: self.url(), token: @token, api_key: @api_key, endpoint: @endpoint)
      if response.was_successful?
        self.populate_from_response(response)
      end
    end

    def save(options_hash={})
      token = @token || options_hash[:token]
      api_key = @api_key || options_hash[:api_key]
      endpoint = @endpoint || options_hash[:endpoint]

      if is_new?
        puts "Saving existing #{@id_attribute}"
        response = SlidePay.put(token: @token, api_key: @api_key, path: "#{@resource_name}/#{self[@id_attribute]}", data: self.to_json)
      else
        puts "Saving new #{@id_attribute}"
        response = SlidePay.post(token: @token, api_key: @api_key, path: "#{@resource_name}", data: self.to_json)
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

      response = SlidePay.delete(path: self.url(), token: @token, api_key: @api_key, endpoint: @endpoint)
      if response.was_successful?
        self[@id_attribute] = nil
        true
      else
        false
      end
    end
  end
end
