$:.unshift(File.join(File.dirname(__FILE__), 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), 'spec'))

require 'multi_json'
require 'slidepay'
require 'spec_helper'

include SlidePay

SlidePay.configure(development: true)
SlidePay.api_key = ENV["api_key"]

# RestClient.proxy = "http://127.0.0.1:8888"

# a = ApiKey.new
# a["api_key_id"] = 17
# a.is_new?
# a.id_attribute
# a.retrieve()

p = Payment.new
p["amount"] = 1.01
p["method"] = "CreditCard"
p["cc_number"] = "4111111111111111"
p["cc_cvv2"] = "111"
p["cc_billing_zip"] = "11111"
p["cc_expiry_month"] = "10"
p["cc_expiry_year"] = "14"
r = p.process()
p.refund()


