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
    describe "list" do
      it "should use the resource's url_root with the SlidePay.get method" do
        c = SlidePay::Client.new(api_key: "TEST_API_KEY", token: "TEST_TOKEN", endpoint: "TEST_ENDPOINT")
        b = SlidePay::BankAccount.new()
        SlidePay.should_receive(:get).with(path: b.url_root, api_key: "TEST_API_KEY", token: "TEST_TOKEN", endpoint: "TEST_ENDPOINT").and_return(a_response_object(bank_account_array_response))
        c.list(b)
      end

      it "should return an array" do
        c = SlidePay::Client.new(api_key: "TEST_API_KEY", token: "TEST_TOKEN", endpoint: "TEST_ENDPOINT")
        b = SlidePay::BankAccount.new()
        SlidePay.stub(:request) { a_response_object(bank_account_array_response) }

        bank_accounts = c.list(b)
        expect(bank_accounts).to be_a(Array)
      end

      it "should return an array of the proper length" do
        c = SlidePay::Client.new(api_key: "TEST_API_KEY", token: "TEST_TOKEN", endpoint: "TEST_ENDPOINT")
        b = SlidePay::BankAccount.new()
        SlidePay.stub(:request) { a_response_object(bank_account_array_response) }

        bank_accounts = c.list(b)
        expect(bank_accounts).to be_a(Array)
      end

      it "should return an array of resources of the proper type" do
        c = SlidePay::Client.new(api_key: "TEST_API_KEY", token: "TEST_TOKEN", endpoint: "TEST_ENDPOINT")
        b = SlidePay::BankAccount.new()
        SlidePay.stub(:request) { a_response_object(bank_account_array_response) }

        bank_accounts = c.list(b)
        expect(bank_accounts).to be_a(Array)
        expect(bank_accounts.length).to eq(2)
        expect(bank_accounts[0]).to be_a(SlidePay::BankAccount)
        expect(bank_accounts[1]).to be_a(SlidePay::BankAccount)
      end
    end

    describe "retrieve" do
      it "should use the resource's method for fulfillment" do
        c = SlidePay::Client.new(api_key: "TEST_API_KEY", token: "TEST_TOKEN", endpoint: "TEST_ENDPOINT")
        b = SlidePay::BankAccount.new()
        b.should_receive(:retrieve).with(api_key: "TEST_API_KEY", token: "TEST_TOKEN", endpoint: "TEST_ENDPOINT")
        c.retrieve(b)
      end
    end

    describe "save" do
      it "should use the resource's method for fulfillment" do
        c = SlidePay::Client.new(api_key: "TEST_API_KEY", token: "TEST_TOKEN", endpoint: "TEST_ENDPOINT")
        b = SlidePay::BankAccount.new()
        b.should_receive(:save).with(api_key: "TEST_API_KEY", token: "TEST_TOKEN", endpoint: "TEST_ENDPOINT")
        c.save(b)
      end
    end

    describe "destroy" do
      it "should use the resource's method for fulfillment" do
        c = SlidePay::Client.new(api_key: "TEST_API_KEY", token: "TEST_TOKEN", endpoint: "TEST_ENDPOINT")
        b = SlidePay::BankAccount.new("bank_account_id" => 1)
        b.should_receive(:destroy).with(api_key: "TEST_API_KEY", token: "TEST_TOKEN", endpoint: "TEST_ENDPOINT")
        c.destroy(b)
      end
    end
  end
end