#! ruby -Ku

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get "/" do
  "ironnews-helper2 v4"
end

require "hpricot"

get "/hatena_bookmark/get_pref" do
  erb(:test)
end
