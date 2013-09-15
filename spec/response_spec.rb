require 'slidepay'
require 'spec_helper'

describe SlidePay::Response do
  def public_methods
    [:success, :custom, :operation, :endpoint, :timezone, :method, :obj,
     :id, :milliseconds, :data, :data_md5]
  end

  it "should be a String" do
    expect(SlidePay::Response.superclass).to eq(String)
  end

  it "should have a bunch of public instance methods" do
    actual_public_methods = SlidePay::Response.public_instance_methods
    public_methods.each do |method|
      expect(actual_public_methods).to include(method)
    end
  end

  describe "constructor" do
    it "should create a blank instance if no string is provided" do
      r = SlidePay::Response.new
      expect(r).to eq("")
    end

    # it "should raise an error if created with invalid JSON" do
    #   expect(SlidePay::Response.new("THIS IS NOT JSON")).to raise_error
    # end

    it "should set the response to any string passed in" do
      json = "{ \"custom\": \"CUSTOM_VALUE\" }"

      r = SlidePay::Response.new(json)

      expect(r).to eq(json)
    end

    it "should try to parse any JSON string passed in on creation" do
      json = "{ \"custom\": \"CUSTOM_VALUE\" }"

      r = SlidePay::Response.new(json)
      expect(r.custom).to eq("CUSTOM_VALUE")
    end
  end

  describe "parse_object_from_json" do
    it "should populate the object when given a valid SlidePay response JSON" do
      r = SlidePay::Response.new(successful_endpoint_response)

      expect(r).to eq(successful_endpoint_response)

      expect(r.success).to eq(true)
      expect(r.custom).to eq(nil)
      expect(r.operation).to eq("GET endpoint")
      expect(r.endpoint).to eq("https://api.getcube.com:65532#{SlidePay::ENDPOINT_SUFFIX}")
      expect(r.timezone).to eq(nil)
      expect(r.method).to eq("GET")
      expect(r.obj).to eq(nil)
      expect(r.id).to eq(0)
      expect(r.milliseconds).to eq("31.25")
      expect(r.data).to eq("https://api.getcube.com:65532/rest.svc/API/")
      expect(r.data_md5).to eq("15D13569C731E9D77ABDCB3348A2EBDD")
    end

    it "should populate the data property of the response with an object when appropriate" do
      r = SlidePay::Response.new(successful_token_detail_response)

      response_object = object_from_response(successful_token_detail_response)

      expect(r.data).to be_a(Hash)
      expect(r.data).to eq(response_object["data"])
    end

    it "should populate the data property of the response with an array when appropriate" do
      r = SlidePay::Response.new(successful_array_response)

      response_object = object_from_response(successful_array_response)

      expect(r.data).to be_a(Array)
      expect(r.data).to eq(response_object["data"])
    end
  end

  describe "was_successful?" do
    it "should always return a boolean" do
      r = SlidePay::Response.new("{\"success\" : true}")
      expect(r.was_successful?).to be_a(TrueClass)

      r = SlidePay::Response.new("{\"success\" : false}")
      expect(r.was_successful?).to be_a(FalseClass)
    end

    it "should return true for a successful response" do
      r = SlidePay::Response.new(successful_endpoint_response)
      expect(r.was_successful?).to eq(true)
    end

    it "should return false for an unsuccessful response" do
      r = SlidePay::Response.new(failed_endpoint_response)
      expect(r.was_successful?).to eq(false)
    end
  end

  describe "endpoint" do
    it "should always include the SlidePay endpoint suffix" do
      r = SlidePay::Response.new
      expect(r.endpoint).to include(SlidePay::ENDPOINT_SUFFIX)
    end

    it "should add the endpoint suffix to the endpoint value retrieved" do
      r = SlidePay::Response.new(successful_token_detail_response)
      response_object = object_from_response(successful_token_detail_response)
      expect(r.endpoint).to eq("#{response_object["endpoint"]}#{SlidePay::ENDPOINT_SUFFIX}")
    end
  end

  describe "error" do
    it "should return nil for a successful response" do
      r = SlidePay::Response.new(successful_token_detail_response)
      expect(r.error).to eq(nil)
    end

    it "should return a Hash object for an unsuccessful response" do
      r = SlidePay::Response.new(failed_token_detail_response)
      expect(r.error).to be_a(Hash)
    end

    it "should return an object containing an error_code and error_text" do
      r = SlidePay::Response.new(failed_token_detail_response)
      expect(r.error).to include("error_text")
      expect(r.error).to include("error_code")
    end
  end
end