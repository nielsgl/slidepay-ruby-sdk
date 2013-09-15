module SlidePay
  class Response < String

    attr_accessor :success, :custom, :operation, :endpoint, :timezone,
                  :method, :obj, :id, :milliseconds, :data, :data_md5

    def initialize(response_json=nil)
      if response_json
        replace response_json
        parse_object_from_json
      end
    end

    def parse_object_from_json
      object = MultiJson.decode(self)

      @success = object['success']
      @custom = object['custom']
      @operation = object['operation']
      @endpoint = object['endpoint']
      @timezone = object['timezone']
      @method = object['method']
      @obj = object['obj']
      @id = object['id']
      @milliseconds = object['milliseconds']
      @data = object['data']
      @data_md5 = object['data_md5']
    end

    def was_successful?
      @success == true
    end

    # response metadata fields
    def endpoint
      "#{@endpoint}#{ENDPOINT_SUFFIX}"
    end

    # error fields
    def error
      if was_successful? == false
        @data
      else
        nil
      end
    end

    def error_code
      if error
        @data['error_code']
      end
    end

    def error_text
      if error
        @data['error_text']
      end
    end
  end
end