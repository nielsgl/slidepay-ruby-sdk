require "slidepay"
require "spec_helper"

describe SlidePay::ApiKey do
  it "should have an id_attribute" do
    b = SlidePay::ApiKey.new()
    expect(b.id_attribute).to eq("api_key_id")
  end

  it "should have a root url" do
    b = SlidePay::ApiKey.new()
    expect(b.url_root).to eq("api_key")
  end

  describe "url" do
    it "should not append the object id if no id is set" do
      b = SlidePay::ApiKey.new()
      expect(b.url()).to eq("api_key")
    end

    it "should append the object id if set" do
      b = SlidePay::ApiKey.new("api_key_id" => 2)
      expect(b.url()).to eq("api_key/2")
    end
  end

  describe "id" do
    it "should return nil if the id is not set" do
      b = SlidePay::ApiKey.new()
      expect(b.id()).to eq(nil)
    end

    it "should return the id if it is present" do
      b = SlidePay::ApiKey.new("api_key_id" => 2)
      expect(b.id()).to eq(2)
    end
  end
end