module SlidePay
  class Response < String
    attr_accessor :response_json

    attr_accessor :success, :custom, :operation, :endpoint, :timezone,
                  :method, :obj, :id, :milliseconds, :data, :data_md5

    def initialize(response_json)

      parse_object_from_json
    end

    def parse_object_from_json
      object = MultiJson.load(@response_json)

      self.merge! object
    end
    private :parse_object_from_json

    def was_successful?
      @success
    end

    # response metadata fields
    def endpoint
      "#{@endpoint}#{SlidePay.ENDPOINT_SUFFIX}"
    end

    # error fields
    def error
      @data
    end

    def error_code
      @data['error_code']
    end

    def error_text
      @data['error_text']
    end
  end
end