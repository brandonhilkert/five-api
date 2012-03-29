require 'bundler'
require 'sinatra/reloader'
Bundler.require

class FiveApi < Sinatra::Base
  enable  :raise_errors, :logging

  configure do
    # Load MongoDB using MongoMapper
    mongo_config = ::Pathname.new(File.join(root, "config", "mongo.yml"))

    if mongo_config.file?
      config = ::YAML.load(ERB.new(mongo_config.read).result)
      ::MongoMapper.setup(config, settings.environment.to_s)
    end
  end
  
  configure :development do
    register Sinatra::Reloader
  end

  get "/api/test" do
    "hello worldasdf"
  end

  get "/api/users/:id" do
    user = User.find(params[:id])
    {
      name:               user.name,
      screen_name:        user.screen_name,
      profile_image_url:  user.profile_image_url,
      wants:              user.wants,
      success:            true

    }.to_json
  end

  put "/api/users/:id" do
    user = User.first
    response = user.update_attributes()
    { success: response }.to_json
  end

  not_found { error_response "We're sorry, but we're unable to find the resource you're looking for." }
  error { error_response "We're sorry, but we're unable to process your request at this time." }

  def api_user
    User.find_by_login(params[:user_login]) ||
    User.find_by_alias(params[:user_login])
  end

  def api_authenticate
    if api_user
      true
    else
      halt error_response("You must supply a valid `user_login` in your requests.")
    end
  end

  def error_response(msg)
    { error: msg }.to_json
  end
end

Dir[Pathname.new("app/**/*.rb")].each {|f| require_relative f}
