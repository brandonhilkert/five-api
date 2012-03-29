require_relative File.join('..', 'five.rb')

require 'rack/test'
require 'rspec'

set :environment, :test

Rspec.configure do |config|

  config.include Rack::Test::Methods

  config.after(:each) do

    # Clear out MongoDB before each test
    MongoMapper.database.collections.each do |collection|
      collection.remove unless collection.name.match(/^system\./)
    end

  end
end

def app
  Five
end