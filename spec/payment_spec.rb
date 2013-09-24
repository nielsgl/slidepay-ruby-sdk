require "slidepay"
require "spec_helper"

describe SlidePay::Payment do
  it "should have an id_attribute" do
    p = SlidePay::Payment.new()
    expect(p.id_attribute).to eq("payment_id")
  end

  it "should have a root url" do
    p = SlidePay::Payment.new()
    expect(p.url_root).to eq("payment")
  end

  describe "url" do
    it "should not append the object id if no id is set" do
      p = SlidePay::Payment.new()
      expect(p.url()).to eq("payment")
    end

    it "should append the object id if set" do
      p = SlidePay::Payment.new("payment_id" => 2)
      expect(p.url()).to eq("payment/2")
    end
  end

  describe "id" do
    it "should return nil if the id is not set" do
      p = SlidePay::Payment.new()
      expect(p.id()).to eq(nil)
    end

    it "should return the id if it is present" do
      p = SlidePay::Payment.new("payment_id" => 2)
      expect(p.id()).to eq(2)
    end
  end

  describe "save" do
    it "should call the process method" do
      p = SlidePay::Payment.new()
      p.should_receive(:process)
      p.save()
    end
  end

  describe "destroy" do
    it "should call the refund method" do
      p = SlidePay::Payment.new()
      p.should_receive(:refund)
      p.destroy()
    end
  end

  describe "process" do
    it "should set the payment_id and the order_master_id on success" do
      SlidePay.stub(:post) { a_response_object(successful_payment_response) }

      p = SlidePay::Payment.new()
      expect(p["order_master_id"]).to eq(nil)
      expect(p["payment_id"]).to eq(nil)
      p.process()
      expect(p["order_master_id"]).to eq("10") # Test data found in spec_helper
      expect(p["payment_id"]).to eq("12")
    end

    it "should raise an error on failure" do
      SlidePay.stub(:post) { a_response_object(failed_payment_response) }

      p = SlidePay::Payment.new()
      expect{ p.process() }.to raise_error("TEST_PAYMENT_FAILED_MESSAGE")
    end
  end

  describe "refund" do
    it "should return false for failure" do
      SlidePay.stub(:post) { a_response_object(failed_object_response) }

      p = SlidePay::Payment.new()
      expect(p.refund()).to eq(false)
    end

    it "should return true for successful refund" do
      SlidePay.stub(:post) { a_response_object(successful_object_response) }

      p = SlidePay::Payment.new()
      expect(p.refund()).to eq(true)
    end
  end
end