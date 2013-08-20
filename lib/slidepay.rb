require "rest_client"

class SlidePay

  @email = nil
  @password = nil
  @endpoint = "https://supervisor.getcube.com:65532/rest.svc/api/"

  USE_PROXY = false
  PROXY_URL = "http://localhost:8888"


  def apiRequest(type, urlStub, data=nil, options=nil)
    # Measure Request Time
    startTime = Time.now

    url = @endpoint + urlStub

    # Make sure that options is not nil
    if options.nil?
      options = {}
    elsif options.kind_of? String
      options_obj = {}
      options_obj[options] = options
      options = options_obj
    end
    options["content-type"] = "application/json"

    begin
      # Use the proxy if option is specified
      if USE_PROXY
        RestClient.proxy = PROXY_URL
      end

      if type.eql? "GET"
        response = RestClient.get url, options
      elsif type.eql? "POST"
        response = RestClient.post url, data, options
      elsif type.eql? "PUT"
        response = RestClient.put url, data, options
      elsif type.eql? "DELETE"
        response = RestClient.delete url, options
      end
    rescue => e
      logger.debug "[apiRequest] Rescue block called - #{e}"
      response = e.response

      # Log request error
      # report_api_request_error(email, type, urlStub, options.to_json, data, response, e)
    end

    # Get reponse time
    endTime = Time.now
    responseTime = (endTime - startTime) * 1000
    logger.debug "[RequestHelper] Request to #{url} took #{responseTime}ms"
    logger.debug "[RequestHelper] Response: \n"
    logger.debug puts response

    return response
  end

end
