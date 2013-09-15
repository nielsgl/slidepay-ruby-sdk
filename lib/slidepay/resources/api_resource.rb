module SlidePay
  class ApiResource
    def url
      @name
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

    def retrieve
      if response.was_successful?
        self.merge! response.data
      else
        raise Exception(response.error_text)
      end
    end

    def save
      puts "ApiResource.save called"
      if is_new?
        puts "Saving existing #{@id_attribute}"
        SlidePay.put(token: @token, api_key: @api_key, path: "#{@name}/#{self[@id_attribute]}", data: self.to_json)
      else
        puts "Saving new #{@id_attribute}"
        SlidePay.post(token: @token, api_key: @api_key, path: "#{@name}", data: self.to_json)
      end
    end

    def create
      puts "ApiResource.create called #{@id_attribute}"
    end

    def destroy
      puts "ApiResource.destroy called #{@id_attribute}"
    end
  end
end
