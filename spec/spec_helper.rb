require 'rubygems'
require 'factory_girl'
require 'rspec'
require 'rack/test'
require 'shoulda-matchers'
require 'capybara'
require 'capybara/rspec'

# All our specs should require 'spec_helper' (this file)

# If RACK_ENV isn't set, set it to 'test'.  Sinatra defaults to development,
# so we have to override that unless we want to set RACK_ENV=test from the
# command line when we run rake spec.  That's tedious, so do it here.
ENV['RACK_ENV'] = 'test'

FactoryGirl.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods
  
  config.before(:all) do
    ActiveRecord::Base.configurations = YAML.load_file('./config/database.yml')
    ActiveRecord::Base.establish_connection(:test)
  end

  config.after(:all) do
    ActiveRecord::Base.connection.close
  end
end

