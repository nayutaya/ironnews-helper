#! ruby -Ku

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get "/" do
  "ironnews-helper2 v4"
end

require "hpricot"

get "/hatena_bookmark/get_area" do
  #url = "http://b.hatena.ne.jp/entry/gigazine.net/index.php?/news/comments/20100121_paragon_backup_recovery_free/"
  url = "http://b.hatena.ne.jp/entry/alfalfalfa.com/archives/383013.html"

  res = AppEngine::URLFetch.fetch(url)
  src = res.body
  doc = Hpricot.parse(src)

  return doc.inspect
end
