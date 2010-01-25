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

=begin
get "/test" do
  erb(:test)
end
=end

=begin
get "/test" do
  require "lib/google_ajax_feeds_api"
  url = GoogleAjaxFeedsApi.create_url(:url => "http://api.tetsudo.com/news/atom.xml")
  response = AppEngine::URLFetch.fetch(url, :deadline => 10)
  return response.body
end
=end

=begin
get "/test" do
  require "lib/google_news"
  return GoogleNews.fetch_rss(:keyword => "鉄道")
end
=end

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
