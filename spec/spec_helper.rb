require 'scene7-wrapper'
require 'savon_spec'
require 'timecop'

RSpec.configure do |config|
  config.include Savon::Spec::Macros

  config.before(:each) do
    Scene7::Client.reset_configuration
  end
end

Savon::Spec::Fixture.path = File.join(File.dirname(__FILE__), 'fixtures')
Savon.configure do |config|
  config.log = false
end
