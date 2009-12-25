
require 'appengine-rack'

AppEngine::Rack.configure_app(
    :application => "ironnews-helper2",
    :version     => "ruby1")

run lambda { Rack::Response.new("Hello World!").finish }
