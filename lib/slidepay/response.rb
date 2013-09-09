module SlidePay
  module Response

    def get_object_from_json(response_json)
    end

    def was_successful?(response_json)
    end

    # response metadata fields
    def endpoint
    end

    def method
    end

    def method_name
    end

    # main response data
    def data
    end

    # error fields
    def error
    end

    def error_code
    end

    def error_text
    end
  end
end