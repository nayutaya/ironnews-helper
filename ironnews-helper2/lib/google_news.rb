
require "cgi"
require "uri"
require "net/http"
require "rss"

if RUBY_PLATFORM =~ /jruby/
  require "appengine-apis/urlfetch"
  Net::HTTP = AppEngine::URLFetch::HTTP
end

Net::HTTP.version_1_2

module GoogleNews
  def self.create_params(options = {})
    options = options.dup
    keyword = options.delete(:keyword) || raise(ArgumentError)
    num     = options.delete(:num) || 10
    raise(ArgumentError) unless options.empty?

    return {
      "hl"     => "ja",
      "ned"    => "us",
      "ie"     => "UTF-8",
      "oe"     => "UTF-8",
      "output" => "rss",
      "num"    => num.to_s,
      "q"      => keyword,
    }
  end

  def self.create_base_url
    return "http://news.google.com/news"
  end

  def self.encode_params(params)
    return params.
      sort_by { |key, value| key }.
      map     { |key, value| "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}" }.
      join("&")
  end

  def self.create_url(options = {})
    options = options.dup
    keyword = options.delete(:keyword) || nil
    num     = options.delete(:num)     || nil
    raise(ArgumentError) unless options.empty?

    params = self.create_params(:keyword => keyword, :num => num)
    return self.create_base_url + "?" + self.encode_params(params)
  end

  # FIXME: タイムアウトの設定
  def self.fetch_url(url)
    uri = URI.parse(url)

    Net::HTTP.start(uri.host, uri.port) { |http|
      response = http.get(uri.request_uri)
      if response.code.to_i == 200
        return response.body
      else
        return nil
      end
    }
  end

  def self.parse_rss(src)
    rss = RSS::Parser.parse(src)
    return rss.items.map { |item|
      Article.new(
        :title => item.title,
        :url   => item.guid.content[/cluster=(.+?)$/, 1])
    }
  end

  def self.search(options = {})
    options = options.dup
    keyword = options.delete(:keyword) || nil
    num     = options.delete(:num)     || nil
    raise(ArgumentError) unless options.empty?

    url   = self.create_url(:keyword => keyword, :num => num)
    rss   = self.fetch_url(url)
    items = self.parse_rss(rss)

    return items
  end

  class Article
    def initialize(options = {})
      options = options.dup
      @title = options.delete(:title)
      @url   = options.delete(:url)
      raise(ArgumentError) unless options.empty?
    end

    attr_reader :title, :url
  end
end
