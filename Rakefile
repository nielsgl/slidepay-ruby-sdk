require "rake"
require "rspec/core/rake_task"
require "bundler/gem_tasks"
require 'rspec'

desc "Run the spec suite"
RSpec::Core::RakeTask.new(:spec) { |t| }

desc "Default task to run the spec suite"
task :default => [:spec]
