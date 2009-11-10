#! ruby -Ku

require "test/unit"
require "cgi"
require "net/http"
require "rubygems"
require "json"

class HatenaTest < Test::Unit::TestCase
  def setup
    @host = "localhost"
    @port = 8080
  end

  def test_get_title__1__by_get
    path = "/hatena-bookmark/get-title"
    data = "url1=" + CGI.escape("http://www.asahi.com/international/update/1110/TKY200911100249.html")

    response = http_get(path + "?" + data)
    assert_equal(200, response.code.to_i)

    expected = {
      "1" => {
        "url"   => "http://www.asahi.com/international/update/1110/TKY200911100249.html",
        "title" => "asahi.com（朝日新聞社）：韓国と北朝鮮の海軍、黄海で一時交戦　聯合ニュース報道 - 国際",
      }
    }
    assert_equal(expected, JSON.parse(response.body))
  end

  def test_get_title__1__by_post
    path = "/hatena-bookmark/get-title"
    data = "url1=" + CGI.escape("http://www.asahi.com/national/update/1110/SEB200911100003.html")

    response = http_post(path, data)
    assert_equal(200, response.code.to_i)

    expected = {
      "1" => {
        "url"   => "http://www.asahi.com/national/update/1110/SEB200911100003.html",
        "title" => "asahi.com（朝日新聞社）：沖縄のひき逃げ事件、米側が陸軍兵の身柄を確保 - 社会",
      }
    }
    assert_equal(expected, JSON.parse(response.body))
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
