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
end
