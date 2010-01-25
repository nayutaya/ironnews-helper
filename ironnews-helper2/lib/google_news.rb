
require "cgi"

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
end
