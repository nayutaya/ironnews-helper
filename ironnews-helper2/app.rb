#! ruby -Ku

require "appengine-apis/logger"
require "json"

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get "/" do
  "ironnews-helper2 v4"
end

get "/test" do
  url = "http://ajax.googleapis.com/ajax/services/feed/load?q=http%3a%2f%2fwww3%2easahi%2ecom%2frss%2findex%2erdf&v=1.0&output=json&num=20"
  response = AppEngine::URLFetch.fetch(url, :deadline => 10)
  return response.body
end

require "lib/hatena_bookmark"

get "/hatena_bookmark/get_pref" do
  #logger = AppEngine::Logger.new
  #AppEngine::Memcache.new.stats

  url  = params[:url]
  pref = HatenaBookmark.get_pref(url)

  {
    "success" => true,
    "url"     => url,
    "pref"    => pref,
  }.to_json
end
