#! ruby -Ku

require "test/unit"
require "cgi"
require "net/http"
require "rubygems"
require "json"

class GoogleNewsTest < Test::Unit::TestCase
  def setup
    if true
      @host = "localhost"
      @port = 8080
    else
      @host = "v3.latest.ironnews-helper2.appspot.com"
      @port = 80
    end

    @search_path = "/google-news/search"
  end

  def test_search__1
    data = "keyword=" + CGI.escape("鉄道")

    response = http_get(@search_path, data)
    assert_equal(200, response.code.to_i)

    body = JSON.parse(response.body)
    assert_equal(10, body.size)
    assert_equal(true, body.all? { |item| item.has_key?("url") })
    assert_equal(true, body.all? { |item| item.has_key?("title") })
  end

  def test_search__2
    data1 = "keyword=" + CGI.escape("鉄道")
    data2 = "keyword=" + CGI.escape("列車")

    response1 = http_get(@search_path, data1)
    response2 = http_get(@search_path, data2)

    body1 = JSON.parse(response1.body)
    body2 = JSON.parse(response2.body)
    assert_not_equal(body1, body2)
  end

  def test_search__3
    data  = "keyword=" + CGI.escape("鉄道")
    data += "&num=20"

    response = http_get(@search_path, data)
    assert_equal(200, response.code.to_i)

    body = JSON.parse(response.body)
    assert_equal(20, body.size)
  end

  private

  def http_get(path, data = nil)
    path += "?" + data if data
    Net::HTTP.start(@host, @port) { |http|
      return http.get(path)
    }
  end
end
