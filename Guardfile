notification :growl

ignore %r{^doc}
guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/.+\.rb$})
  watch(%r{^lib/slidepay/(.+)\.rb$})  { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/slidepay/resources/(.+)\.rb$})  { |m| "spec/#{m[1]}_spec.rb" }
end
