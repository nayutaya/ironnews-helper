
require "cgi"

module GoogleAjaxFeedsApi
  def self.create_parameter(options = {})
    options = options.dup
    url = options.delete(:url) || raise(ArgumentError)
    num = options.delete(:num) || 10
    raise(ArgumentError) unless options.empty?

    return {
      "v"      => "1.0",
      "output" => "json",
      "q"      => url,
      "num"    => num.to_s,
    }
  end

  def self.create_base_url
    return "http://ajax.googleapis.com/ajax/services/feed/load"
  end

  def self.create_url(options = {})
    options = options.dup
    url = options.delete(:url)
    num = options.delete(:num)
    raise(ArgumentError) unless options.empty?

    params = self.create_parameter(:url => url, :num => num)
    query  = params.
      sort_by { |key, value| key }.
      map     { |key, value| CGI.escape(key) + "=" + CGI.escape(value.to_s) }.join("&")
    return self.create_base_url + "?" + query
  end
end
