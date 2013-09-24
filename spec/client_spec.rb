require "slidepay"
require "spec_helper"

describe SlidePay::Client do
  before(:all) do
    SlidePay.configure(development: true)
  end

  it "should allow instantiation with no parameters" do
    c = SlidePay::Client.new
    expect(c).to be_a(SlidePay::Client)
  end

  it "should set api_key, token, and endpoint when they are present" do
    c = SlidePay::Client.new(api_key: "TEST_API_KEY", token: "TEST_TOKEN", endpoint: "TEST_ENDPOINT")

    expect(c.api_key).to  eq("TEST_API_KEY")
    expect(c.token).to  eq("TEST_TOKEN")
    expect(c.endpoint).to  eq("TEST_ENDPOINT")
  end

  describe "basic request methods" do
    describe "get" do
      it "should accept a string" do
        c = SlidePay::Client.new(api_key: "TEST_API_KEY", endpoint: "TEST_ENDPOINT")

        SlidePay.should_receive(:get).with(path: 'test/path', api_key: "TEST_API_KEY", token: nil, endpoint: "TEST_ENDPOINT")
        expect(c.get("test/path")).not_to raise_error
      end

      it "should accept a hash" do
        c = SlidePay::Client.new(api_key: "TEST_API_KEY", endpoint: "TEST_ENDPOINT")

        SlidePay.should_receive(:get).with(path: 'test/path', api_key: "TEST_API_KEY", token: nil, endpoint: "TEST_ENDPOINT")
        expect(c.get(path: "test/path")).not_to raise_error
      end
    end

    describe "post" do
      it "should send the parameters hash with api_key and token to SlidePay" do
        c = SlidePay::Client.new(api_key: "TEST_API_KEY", endpoint: "TEST_ENDPOINT")

        SlidePay.should_receive(:post).with(path: 'test/path', data: "TEST_DATA", api_key: "TEST_API_KEY", token: nil, endpoint: "TEST_ENDPOINT")
        expect(c.post(path: "test/path", data: "TEST_DATA")).not_to raise_error
      end
    end

    describe "put" do
      it "should send the parameters hash with api_key and token to SlidePay" do
        c = SlidePay::Client.new(api_key: "TEST_API_KEY", endpoint: "TEST_ENDPOINT")

        SlidePay.should_receive(:put).with(path: 'test/path', data: "TEST_DATA", api_key: "TEST_API_KEY", token: nil, endpoint: "TEST_ENDPOINT")
        expect(c.put(path: "test/path", data: "TEST_DATA")).not_to raise_error
      end
    end

    describe "delete" do
      it "should accept a string" do
        c = SlidePay::Client.new(api_key: "TEST_API_KEY", endpoint: "TEST_ENDPOINT")

        SlidePay.should_receive(:delete).with(path: 'test/path', api_key: "TEST_API_KEY", token: nil, endpoint: "TEST_ENDPOINT")
        expect(c.delete("test/path")).not_to raise_error
      end

      it "should accept a hash" do
        c = SlidePay::Client.new(api_key: "TEST_API_KEY", endpoint: "TEST_ENDPOINT")

        SlidePay.should_receive(:delete).with(path: 'test/path', api_key: "TEST_API_KEY", token: nil, endpoint: "TEST_ENDPOINT")
        expect(c.delete(path: "test/path")).not_to raise_error
      end
    end
  end

  describe "resource request methods" do

  end
end