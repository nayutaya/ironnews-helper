
require "appengine-rack"

AppEngine::Rack.configure_app(
    :application => "ironnews-helper2",
    :version     => "ruby1")

require "testapp"

run Sinatra::Application
