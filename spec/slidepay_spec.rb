# $:.unshift File.join(File.dirname(__FILE__), "lib")

require "slidepay"

describe SlidePay do
  it "should have a version" do
    SlidePay::VERSION.wont_be_nil
  end
end
