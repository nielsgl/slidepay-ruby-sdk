# $:.unshift File.join(File.dirname(__FILE__), "lib")

require "slidepay"

describe SlidePay do
  def public_methods
    [:set_auth_option, :request, :get, :post, :put, :delete]
  end

  def set_global_api_key
    SlidePay.api_key = "TEST_API_KEY"
  end

  def set_global_token
    SlidePay.token = "TEST_TOKEN"
  end

  def clear_auth_data
    SlidePay.api_key = nil
    SlidePay.token = nil

  end

  it "should have a version" do
    expect(SlidePay::VERSION).not_to be_nil
  end

  it "should have a global token variable" do
    expect(SlidePay.token).to be_nil
  end

  it "should have a global api_key variable" do
    expect(SlidePay.api_key).to be_nil
  end

  it "should have a bunch of public methods" do
    actual_slidepay_methods = SlidePay.public_methods
    public_methods.each do |method|
      expect(actual_slidepay_methods).to include(method)
    end
  end

  describe "set_auth_option" do
    after(:each) do
      clear_auth_data()
    end

    it "should use the default token over the default api_key if both are present" do
      set_global_token()
      set_global_api_key()

      auth = SlidePay.set_auth_option({})
      expect(auth).to eq({ "x-cube-token" => "TEST_TOKEN" })
    end

    it "should use the default api_key when nothing else is given" do
      set_global_api_key()

      auth = SlidePay.set_auth_option({})
      expect(auth).to eq({ "x-cube-api-key" => "TEST_API_KEY" })
    end

    it "should use the default token when nothing else is given" do
      set_global_token()

      auth = SlidePay.set_auth_option({})
      expect(auth).to eq({ "x-cube-token" => "TEST_TOKEN" })
    end

    it "should use the provided api_key even when a default is present" do
      set_global_api_key()

      auth = SlidePay.set_auth_option(api_key: "PASSED_IN_API_KEY")
      expect(auth).to eq({ "x-cube-api-key" => "PASSED_IN_API_KEY" })
    end

    it "should use the provided token even when a default is present" do
      set_global_token()

      auth = SlidePay.set_auth_option(token: "PASSED_IN_TOKEN")
      expect(auth).to eq({ "x-cube-token" => "PASSED_IN_TOKEN" })
    end

  end
end
