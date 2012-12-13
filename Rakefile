require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

# Allows for 'rake' and 'rake spec' to execute specs.  Fixes bug with message:
#   undefined method `shellescape' ...
require 'shellwords'

task :default => :spec
