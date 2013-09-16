require "rake"
require "rspec/core/rake_task"
require "bundler/gem_tasks"
require 'rspec'

desc "Run spec suite"
RSpec::Core::RakeTask.new(:spec) { |t| }

desc "Default the task to run the spec"
task :default => [:spec]
