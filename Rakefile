require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "scene7-wrapper"
  gem.homepage = "http://github.com/factorylabs/scene7-wrapper"
  gem.license = "MIT"
  gem.summary = %Q{A Scene7 wrapper for Rails 3.x apps.}
  gem.description = %Q{A Scene7 wrapper for Rails 3.x apps.}
  gem.email = "brian.rose@factorylabs.com"
  gem.authors = ["Brian Rose", "Jim Whiteman"]
  gem.test_files = []
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

