#! ruby -Ku

require "appengine-apis/logger"
require "appengine-apis/memcache"

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get "/" do
  "ironnews-helper2 v4"
end

require "hpricot"

def get_entry_url(url)
  return url.sub(/^http:\/\//, "http://b.hatena.ne.jp/entry/")
end

get "/hatena_bookmark/get_pref" do
  erb(:test)
end
