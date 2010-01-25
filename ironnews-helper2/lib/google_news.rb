
require "cgi"
require "uri"
require "net/http"

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

  def self.create_url(options = {})
    options = options.dup
    keyword = options.delete(:keyword) || nil
    num     = options.delete(:num)     || nil
    raise(ArgumentError) unless options.empty?

    query = self.create_params(:keyword => keyword, :num => num).
      sort_by { |key, value| key }.
      map     { |key, value| CGI.escape(key) + "=" + CGI.escape(value.to_s) }.join("&")
    return self.create_base_url + "?" + query
  end

  def self.fetch_rss(options = {})
    options = options.dup
    keyword = options.delete(:keyword) || nil
    num     = options.delete(:num)     || nil
    raise(ArgumentError) unless options.empty?

    url = self.create_url(:keyword => keyword, :num => num)
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
end
