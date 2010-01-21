
require "appengine-rack"

AppEngine::Rack.configure_app(
  :precompilation_enabled => true,
  :application => "ironnews-helper2",
  :version     => "v4")

require "sinatra"
require "app"

run Sinatra::Application
