require "slidepay"
require "spec_helper"

describe SlidePay::Client do
  before(:all) do
    # SlidePay = double("SlidePay")
    # SlidePay.stub(:get) { return "get" }
    # SlidePay.stub(:post) { return "post" }
    # SlidePay.stub(:put) { return "put" }
    # SlidePay.stub(:delete) { return "delete" }

    SlidePay.configure(development: true)
  end

  it "should allow instantiation with no parameters" do
    c = SlidePay::Client.new
    expect(c).to be_a(SlidePay::Client)
  end

  it "should set api_key, token, and endpoint whne they are present" do
    c = SlidePay::Client.new(api_key: "TEST_API_KEY", token: "TEST_TOKEN", endpoint: "TEST_ENDPOINT")

    expect(c.api_key).to  eq("TEST_API_KEY")
    expect(c.token).to  eq("TEST_TOKEN")
    expect(c.endpoint).to  eq("TEST_ENDPOINT")
  end

end