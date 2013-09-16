require "slidepay"
require "spec_helper"

describe SlidePay::ApiResource do
  before(:all) do
    # SlidePay = double("SlidePay")
    # SlidePay.stub(:get) { return "get" }
    # SlidePay.stub(:post) { return "post" }
    # SlidePay.stub(:put) { return "put" }
    # SlidePay.stub(:delete) { return "delete" }

    SlidePay.configure(development: true)
  end

  it "should be a Hash" do
    r = SlidePay::ApiResource.new
    expect(r).to be_a(Hash)
  end

  describe "initialize" do
    it "should allow instantiation with no parameters" do
      r = SlidePay::ApiResource.new
      expect(r).to be_a(SlidePay::ApiResource)
    end

    it "should set api_key, token, and endpoint when they are present" do
      resource = SlidePay::ApiResource.new(api_key: "TEST_API_KEY", token: "TEST_TOKEN", endpoint: "TEST_ENDPOINT")

      expect(resource[:api_key]).to  eq(nil)
      expect(resource[:token]).to  eq(nil)
      expect(resource[:endpoint]).to  eq(nil)

      expect(resource.api_key).to  eq("TEST_API_KEY")
      expect(resource.token).to  eq("TEST_TOKEN")
      expect(resource.endpoint).to  eq("TEST_ENDPOINT")
    end

    it "should values for keys other than :api_key, :token, or :endpoint into the instance" do
      resource = SlidePay::ApiResource.new(api_key: "TEST_API_KEY", dog: "Fido", cat: "Dog")

      expect(resource[:api_key]).to  eq(nil)
      expect(resource[:dog]).to  eq("Fido")
      expect(resource[:cat]).to  eq("Dog")
    end
  end

  describe  "to_json" do
    it "should return an empty object for a clean resource" do
      r = SlidePay::ApiResource.new()
      expect(r.to_json).to eq("{}")
    end

    it "should return a json representation of the hash contents" do
      r = SlidePay::ApiResource.new(id: 1, name: "Dog the Bounty Hunter")
      expect(r.to_json).to eq("{\"id\":1,\"name\":\"Dog the Bounty Hunter\"}" )
    end
  end

  describe "is_new?" do
    it "should return true if id_attribute is not set" do
      resource = SlidePay::ApiResource.new(id: 1, name: "Dog the Bounty Hunter")
      expect(resource.is_new?).to be_true
    end

    it "should return true if id_attribute is set but not present in the hash" do
      resource = SlidePay::ApiResource.new(name: "Dog the Bounty Hunter")
      resource.id_attribute = :id

      expect(resource.is_new?).to be_true
    end

    it "should return false if id_attribute is set and present in the hash" do
      resource = SlidePay::ApiResource.new(id: 1, name: "Dog the Bounty Hunter")
      resource.id_attribute = :id

      expect(resource.is_new?).to be_false
    end
  end

  describe "id" do
    it "should return nil if the id_attribute is not set" do
      resource = SlidePay::ApiResource.new(id: 1, name: "Dog the Bounty Hunter")
      expect(resource.id()).to eq(nil)
    end

    it "should return nil if the id_attribute is set but not present in the hash" do
      resource = SlidePay::ApiResource.new(name: "Dog the Bounty Hunter")
      resource.id_attribute = :id
      expect(resource.id()).to eq(nil)
    end

    it "should return the value of the the id_attribute key inside the hash" do
      resource = SlidePay::ApiResource.new(id: 1, name: "Dog the Bounty Hunter")
      resource.id_attribute = :id
      expect(resource.id()).to eq(1)
    end
  end

  describe "url_root" do
    context "when id_attribute is not set but is in the hash" do
      resource = SlidePay::ApiResource.new(id: 1, name: "Dog the Bounty Hunter")
      resource.url_root = "mullet_hero"

      it "should return only the url_root" do
        expect(resource.url()).to eq(resource.url_root)
      end
    end

    context "when id_attribute is set but not in the hash" do
      resource = SlidePay::ApiResource.new(name: "Dog the Bounty Hunter")
      resource.id_attribute = :id
      resource.url_root = "mullet_hero"

      it "should return only the url_root" do
        expect(resource.url()).to eq(resource.url_root)
      end
    end

    context "when id_attribute is set and in the hash" do
      resource = SlidePay::ApiResource.new(id: 1, name: "Dog the Bounty Hunter")
      resource.id_attribute = :id
      resource.url_root = "mullet_hero"

      it "should return a specific path like :url_root/:id_attribute" do
        expect(resource.url()).to eq("#{resource.url_root}/#{resource[resource.id_attribute]}")
      end
    end
  end

  describe "retrieve" do
    it "should raise an exception if the resource has no id" do
      resource = SlidePay::ApiResource.new(name: "Dog the Bounty Hunter")
      expect { resource.retrieve() }.to raise_error
    end

    it "should make a get request if the resource has an id" do
      resource = SlidePay::ApiResource.new(id: 1)
      resource.url_root = "person"
      resource.id_attribute = :id

      SlidePay.should_receive(:get).with(path: "person/1", token: nil, api_key: nil, endpoint: nil).and_return(a_successful_response_object)
      resource.retrieve()
    end

    it "should have the contents of the response when call is successful" do
      resource = SlidePay::ApiResource.new({"id" =>  1})
      resource.url_root = "person"
      resource.id_attribute = "id"

      SlidePay.should_receive(:get).with(path: "person/1", token: nil, api_key: nil, endpoint: nil).and_return(a_successful_response_object)
      resource.retrieve()

      expect(resource["id"]).to eq("1")
      expect(resource["name"]).to eq("Dog the Bounty Hunter")
    end
  end

  describe "save" do
    before(:all) do
      SlidePay.stub(:get) { a_successful_response_object }
      SlidePay.stub(:post) { a_successful_response_object }
      SlidePay.stub(:put) { a_successful_response_object }
    end

    context "when the resource is new (has no id)" do
      it "should make a post request if the resource has no id" do
        resource = SlidePay::ApiResource.new(name: "Dog the Bounty Hunter")
        resource.url_root = "person"
        resource.id_attribute = "id"
        SlidePay.should_receive(:post).with(path: "person", token: nil, api_key: nil, endpoint: nil, data: resource.to_json).and_return(a_successful_response_object)
        resource.save()
      end

      it "should populate the object with the returned values on a successful response" do
        resource = SlidePay::ApiResource.new(name: "Dog the Bounty Hunter")
        SlidePay.should_receive(:post).and_return(a_successful_response_object)
        resource.save()

        expect(resource["id"]).to eq("1")
        expect(resource["name"]).to eq("Dog the Bounty Hunter")
      end
    end

    context "when the resource is not new (has an id)" do
      it "should make a put request if the resource has an id" do
        resource = SlidePay::ApiResource.new(id: 1, name: "---this should be replaced--")
        resource.url_root = "person"
        resource.id_attribute = :id

        SlidePay.should_receive(:put).with(path: "person/1", token: nil, api_key: nil, endpoint: nil, data: resource.to_json).and_return(a_successful_response_object)
        resource.save()
      end

      it "should populate the object with the returned values on a successful response" do
        resource = SlidePay::ApiResource.new(id: 1, name: "---this should be replaced--")
        resource.url_root = "person"
        resource.id_attribute = :id

        SlidePay.should_receive(:put).and_return(a_successful_response_object)
        resource.save()

        expect(resource["id"]).to eq("1")
        expect(resource["name"]).to eq("Dog the Bounty Hunter")
      end
    end
  end

  describe "destroy" do
    it "should raise an error if the resource is new (has no id)" do
      resource = SlidePay::ApiResource.new
      expect { resource.destroy() }.to raise_error
    end

    it "should make a delete request and return true" do
      resource = SlidePay::ApiResource.new(id: 1, name: "Dog the Bounty Hunter")
      resource.id_attribute = :id
      resource.url_root = "person"

      SlidePay.should_receive(:delete).and_return(a_successful_response_object(successful_deletion_response))
      expect(resource.destroy()).to be_true
    end

    it "should delete the id_attribute key/value pair from the hash on deletion" do
      resource = SlidePay::ApiResource.new(id: 1, name: "Dog the Bounty Hunter")
      resource.id_attribute = :id
      resource.url_root = "person"

      SlidePay.should_receive(:delete).and_return(a_successful_response_object(successful_deletion_response))
      expect(resource.destroy()).to be_true
      expect(resource[:id]).to be_nil
    end
  end
end