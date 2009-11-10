#! ruby -Ku

require "test/unit"
require "cgi"
require "net/http"

class HatenaTest < Test::Unit::TestCase
  def setup
    @host = "localhost"
    @port = 8080
  end

  def test_get_title__by_get
    target_url   = "http://www.asahi.com/international/update/1110/TKY200911100249.html"
    service_path = "/hatena-bookmark/get-title?url0=" + CGI.escape(target_url)

    response = http_get(service_path)
p response.code
p response.body
  end

  private

  def http_get(path)
    Net::HTTP.start(@host, @port) { |http|
      return http.get(path)
    }
  end

  def http_post(path, data)
    Net::HTTP.start(@host, @port) { |http|
      return http.post(path, data)
    }
  end
end
