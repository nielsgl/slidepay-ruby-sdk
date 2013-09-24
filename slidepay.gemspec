# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'slidepay/version'

Gem::Specification.new do |spec|
  spec.name          = "slidepay"
  spec.version       = SlidePay::VERSION
  spec.authors       = ["Matt Rothstein"]
  spec.email         = ["matt@slidepay.com"]
  spec.description   = "SlidePay makes it ridiculously easy to take swiped payments anywhere, on any device. Check out http://www.slidepay.com for more info."
  spec.summary       = "SlidePay Ruby SDK"
  spec.homepage      = "http://www.slidepay.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client"
  spec.add_dependency "multi_json"
  spec.add_dependency "json"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec", "~> 2.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "growl"
end
