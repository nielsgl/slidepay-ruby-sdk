require "slidepay"
require "spec_helper"

describe SlidePay do
  def public_methods
    [:get_auth_option, :request, :get, :post, :put, :delete]
  end

  it "should have a version" do
    expect(SlidePay::VERSION).not_to be_nil
  end

  it "should have a global token variable that is nil" do
    expect(SlidePay.token).to be_nil
  end

  it "should have a global api_key variable that is nil" do
    expect(SlidePay.api_key).to be_nil
  end

  it "should have a default endpoint" do
    expect(SlidePay.endpoint).not_to be_nil
  end

  describe "configure" do
    before(:each) do
      clear_slidepay()
    end

    it "should only configure an endpoint by default" do
      SlidePay.configure

      expect(SlidePay.token).to be_nil
      expect(SlidePay.api_key).to be_nil
      expect(SlidePay.endpoint).to eq(SlidePay::SUPERVISOR_URL)
    end

    it "should allow configuration of token, api_key, and endpoint" do
      SlidePay.configure(endpoint: "TEST_ENDPOINT", token: "TEST_TOKEN", api_key: "TEST_API_KEY")

      expect(SlidePay.token).to eq("TEST_TOKEN")
      expect(SlidePay.api_key).to eq("TEST_API_KEY")
      expect(SlidePay.endpoint).to eq("TEST_ENDPOINT")
    end

    it "should allow a user to choose the development enpdoint" do
      SlidePay.configure(development: true)

      expect(SlidePay.endpoint).to eq(SlidePay::DEV_API_URL)
    end
  end

  it "should have a bunch of public methods" do
    actual_slidepay_methods = SlidePay.public_methods
    public_methods.each do |method|
      expect(actual_slidepay_methods).to include(method)
    end
  end

  it "should have a bunch of configuration options" do
    ENDPOINT_SUFFIX   = '/rest.svc/API/'
    SUPERVISOR_URL    = 'https://supervisor.getcube.com:65532/rest.svc/API/'
    PROD_API_URL      = 'https://api.getcube.com:65532/rest.svc/API/'
    DEV_API_URL       = 'https://dev.getcube.com:65532/rest.svc/API/'
    DEBUG             = false

    expect(SlidePay::ENDPOINT_SUFFIX).to eq(ENDPOINT_SUFFIX)
    expect(SlidePay::SUPERVISOR_URL).to eq(SUPERVISOR_URL)
    expect(SlidePay::PROD_API_URL).to eq(PROD_API_URL)
    expect(SlidePay::DEV_API_URL).to eq(DEV_API_URL)
    expect(SlidePay::DEBUG).to eq(DEBUG)
  end

  describe "get_endpoint_option" do
    after(:each) do
      clear_endpoint()
    end

    it "should use the default endpoint if none is provided" do
      set_global_endpoint()

      endpoint = SlidePay.get_endpoint_option({})
      expect(SlidePay.endpoint).to eq("TEST_ENDPOINT")
      expect(endpoint).to eq("TEST_ENDPOINT")
    end

    it "should use the endpoint passed in if there is no default" do
      endpoint = SlidePay.get_endpoint_option(endpoint: "NEW_ENDPOINT")
      expect(SlidePay.endpoint).to eq(nil)
      expect(endpoint).to eq("NEW_ENDPOINT")
    end

    it "should use the endpoint passed in over the default" do
      set_global_endpoint()

      endpoint = SlidePay.get_endpoint_option(endpoint: "NEW_ENDPOINT")
      expect(SlidePay.endpoint).to eq("TEST_ENDPOINT")
      expect(endpoint).to eq("NEW_ENDPOINT")
    end
  end


  describe "get_auth_option" do
    after(:each) do
      clear_auth_data()
    end

    it "should use the default token over the default api_key if both are present" do
      set_global_token()
      set_global_api_key()

      auth = SlidePay.get_auth_option({})
      expect(SlidePay.token).to eq("TEST_TOKEN")
      expect(SlidePay.api_key).to eq("TEST_API_KEY")
      expect(auth).to eq({ "x-cube-token" => "TEST_TOKEN" })
    end

    it "should use the default api_key when nothing else is given" do
      set_global_api_key()

      auth = SlidePay.get_auth_option({})
      expect(SlidePay.token).to eq(nil)
      expect(SlidePay.api_key).to eq("TEST_API_KEY")
      expect(auth).to eq({ "x-cube-api-key" => "TEST_API_KEY" })
    end

    it "should use the default token when nothing else is given" do
      set_global_token()

      auth = SlidePay.get_auth_option({})
      expect(SlidePay.token).to eq("TEST_TOKEN")
      expect(SlidePay.api_key).to eq(nil)
      expect(auth).to eq({ "x-cube-token" => "TEST_TOKEN" })
    end

    it "should use the provided api_key even when a default is present" do
      set_global_api_key()

      auth = SlidePay.get_auth_option(api_key: "PASSED_IN_API_KEY")
      expect(SlidePay.token).to eq(nil)
      expect(SlidePay.api_key).to eq("TEST_API_KEY")
      expect(auth).to eq({ "x-cube-api-key" => "PASSED_IN_API_KEY" })
    end

    it "should use the provided token even when a default is present" do
      set_global_token()

      auth = SlidePay.get_auth_option(token: "PASSED_IN_TOKEN")
      expect(SlidePay.token).to eq("TEST_TOKEN")
      expect(SlidePay.api_key).to eq(nil)
      expect(auth).to eq({ "x-cube-token" => "PASSED_IN_TOKEN" })
    end
  end

  describe "request" do
    before(:each) do
      SlidePay.configure(development: true)

      # RestClient = double("RestClient")
      # RestClient.stub(:get) { failed_endpoint_response}
      # RestClient.stub(:put) { failed_endpoint_response}
      # RestClient.stub(:post) { failed_endpoint_response}
      # RestClient.stub(:delete) { failed_endpoint_response}
    end

    it "should always return a SlidePay::Response object" do
      r_get = SlidePay.request("GET", { :path => 'login'})
      r_put = SlidePay.request("PUT", { :path => 'login'})
      r_post = SlidePay.request("POST", { :path => 'login'})
      r_delete = SlidePay.request("DELETE", { :path => 'login'})

      expect(r_get).to be_a(SlidePay::Response)
      expect(r_put).to be_a(SlidePay::Response)
      expect(r_post).to be_a(SlidePay::Response)
      expect(r_delete).to be_a(SlidePay::Response)
    end

    it "should raise an error for invalid request types" do
      expect { SlidePay.request("INVALID_TYPE", {}) }.to raise_error
    end
  end

  describe "retrieve_token" do
    before(:all) do
      clear_slidepay
      SlidePay.configure(development: true)
    end

    it "should always return a SlidePay::Response" do
      r = SlidePay.retrieve_token('','')
      expect(r).to be_a(SlidePay::Response)
    end

    it "should return a token value on success" do
      r = SlidePay.retrieve_token(SlidePay::TEST_EMAIL,SlidePay::TEST_PASSWORD)

      expect(r.data).to be_a(String)
    end

    it "should return an error object on failure" do
      r = SlidePay.retrieve_token('','')

      expect(r.data).to be_a(Hash)
      expect(r.error).to be_a(Hash)
    end
  end

  describe "retrieve_endpoint" do
    before(:all) do
      clear_slidepay
      SlidePay.configure()
    end

    it "should always return a string" do
      r = SlidePay.retrieve_endpoint('')
      expect(r).to be_a(SlidePay::Response)
    end

    it "should return an endpoint value on success" do
      r = SlidePay.retrieve_endpoint('matt+test@getcube.com')

      expect(r.data).to be_a(String)
      expect(r.data).to include("getcube.com")
    end

    it "should return an error object on failure" do
      r = SlidePay.retrieve_endpoint('')

      expect(r.data).to be_a(Hash)
      expect(r.error).to be_a(Hash)
    end
  end

  describe "get" do
    before(:all) do
      SlidePay.configure(development: true)
      set_global_api_key_from_env
    end

    it "should accept a string" do
      expect(SlidePay.get('token/detail')).to be_a(SlidePay::Response)
    end

    it "should accept a hash" do
      expect(SlidePay.get(path: 'token/detail')).to be_a(SlidePay::Response)
    end
  end

  describe "delete" do
    before(:all) do
      SlidePay.configure(development: true)
      set_global_api_key_from_env
    end

    it "should accept a string" do
      expect(SlidePay.delete('fictional_object/2')).to be_a(SlidePay::Response)
    end

    it "should accept a hash" do
      expect(SlidePay.delete(path: 'fictional_object/2')).to be_a(SlidePay::Response)
    end
  end

  describe "authenticate" do
    before(:each) do
      clear_slidepay
      SlidePay.configure(development: true)
    end

    it "should have a token after a successful authentication" do
      expect(SlidePay.authenticate(SlidePay::TEST_EMAIL, SlidePay::TEST_PASSWORD)).to eq(true)
      expect(SlidePay.token).not_to eq(nil)
    end

    it "should not have a token after a successful authentication" do
      expect(SlidePay.authenticate('','')).to eq(false)
      expect(SlidePay.token).to eq(nil)
    end
  end

end
