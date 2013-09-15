$:.unshift(File.join(File.dirname(__FILE__), '../'))

require 'multi_json'
require 'pathname'

if Pathname.new('environment.rb').exist?
  require 'environment'
end

module SlidePay
  TEST_EMAIL = ENV["email"]
  TEST_PASSWORD = ENV["password"]
  TEST_API_KEY = ENV["api_key"]
end

def set_global_api_key_from_env
  SlidePay.api_key = SlidePay::TEST_API_KEY
end

def set_global_api_key
  SlidePay.api_key = "TEST_API_KEY"
end

def set_global_token
  SlidePay.token = "TEST_TOKEN"
end

def set_global_endpoint
  SlidePay.endpoint = "TEST_ENDPOINT"
end

def clear_auth_data
  SlidePay.api_key = nil
  SlidePay.token = nil
end

def clear_endpoint
  SlidePay.endpoint = nil
end

def clear_slidepay
  SlidePay.token = nil
  SlidePay.api_key = nil
  SlidePay.endpoint = nil
end

def object_from_response(json)
  MultiJson.decode(json)
end

def successful_endpoint_response
  <<-eos
  {
    "success": true,
    "custom": null,
    "operation": "GET endpoint",
    "endpoint": "https://api.getcube.com:65532",
    "timezone": null,
    "method": "GET",
    "obj": null,
    "id": 0,
    "milliseconds": "31.25",
    "data": "https://api.getcube.com:65532/rest.svc/API/",
    "data_md5": "15D13569C731E9D77ABDCB3348A2EBDD"
  }
  eos
end

def failed_endpoint_response
  <<-eos
  {
    "success": false,
    "custom": null,
    "operation": "GET endpoint",
    "endpoint": null,
    "timezone": null,
    "method": "GET",
    "obj": null,
    "id": 0,
    "milliseconds": "0.00",
    "data": {
      "error_code": "4",
      "error_file": "i_http_handler.cs",
      "error_text": "Unable to process your request at this time.  Unable to locate an endpoint for your account."
    },
    "data_md5": null
  }
  eos
end

def successful_array_response
  <<-eos
  {
    "success": true,
    "custom": null,
    "operation": "GET customer",
    "endpoint": "https://dev.getcube.com:65532",
    "timezone": "",
    "method": "get",
    "obj": null,
    "id": 0,
    "milliseconds": "15.62",
    "data": [
      {
        "customer_id": 211,
        "company_id": 213,
        "location_id": 285,
        "user_master_id": 297,
        "first_name": "Father",
        "middle_name": "",
        "last_name": "Yummy Bears",
        "company_name": "",
        "address_1": "",
        "address_2": "",
        "address_3": "",
        "city": "",
        "state": "",
        "postal_code": "",
        "country": "",
        "email": "",
        "home_phone": "",
        "cell_phone": "1234567890",
        "twitter_id": "",
        "facebook_email": "",
        "homepage": "",
        "active": 1,
        "created": "2013-09-06T04:05:49",
        "last_update": "2013-09-06T04:05:49"
      },
      {
        "customer_id": 210,
        "company_id": 213,
        "location_id": 285,
        "user_master_id": 297,
        "first_name": "Customer",
        "middle_name": "",
        "last_name": "Robot Rabbit",
        "company_name": "",
        "address_1": "",
        "address_2": "",
        "address_3": "",
        "city": "",
        "state": "",
        "postal_code": "",
        "country": "",
        "email": "",
        "home_phone": "",
        "cell_phone": "2222222222",
        "twitter_id": "",
        "facebook_email": "",
        "homepage": "",
        "active": 1,
        "created": "2013-09-05T16:57:33",
        "last_update": "2013-09-05T16:57:33"
      }
    ],
    "data_md5": "2B4A5BF8C70C97022E4824643E96C695"
  }
  eos
end

def successful_token_detail_response
  <<-eos
  {
    "success": true,
    "custom": null,
    "operation": "GET token detail",
    "endpoint": "https://dev.getcube.com:65532",
    "timezone": "",
    "method": "get",
    "obj": null,
    "id": 0,
    "milliseconds": "15.62",
    "data": {
      "created": "2013-09-15T01:11:20",
      "server_name": "cubeuswdev1",
      "endpoint": "https://dev.getcube.com:65532",
      "email": "marothstein@gmail.com",
      "password": null,
      "ip_address": "50.193.11.137",
      "random": null,
      "timezone": "",
      "company_id": 18,
      "company_name": "Cube",
      "location_id": 14,
      "location_name": "Cube",
      "user_master_id": 138,
      "first_name": "Matty",
      "last_name": "Rothstein",
      "is_clerk": 1,
      "is_locmgr": 1,
      "is_comgr": 1,
      "is_admin": 0,
      "is_isv": 0
    },
    "data_md5": "2B4A5BF8C70C97022E4824643E96C695"
  }
  eos
end

def failed_token_detail_response
  <<-eos
  {
    "success": false,
    "custom": null,
    "operation": "get /API/token/detail",
    "endpoint": "https://dev.getcube.com:65532",
    "timezone": null,
    "method": "get",
    "obj": null,
    "id": 0,
    "milliseconds": "15.62",
    "data": {
      "error_code": "6",
      "error_file": "i_http_handler.cs",
      "error_text": "Token not present.  Please login."
    },
    "data_md5": null
  }
  eos
end

def successful_payment_response
  <<-eos
  eos
end

def failed_payment_response
  <<-eos
  eos
end