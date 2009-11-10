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

  def test_get_title__10__by_post
    data = [
      "http://www.asahi.com/national/update/1110/TKY200911100156.html",
      "http://www.asahi.com/national/update/1110/TKY200911100251.html",
      "http://www.asahi.com/national/update/1110/TKY200911100106.html",
      "http://www.asahi.com/sports/update/1110/TKY200911100172.html",
      "http://www.asahi.com/national/update/1110/SEB200911100004.html",
      "http://www.asahi.com/international/update/1110/TKY200911100277.html",
      "http://www.asahi.com/national/update/1110/NGY200911100005.html",
      "http://www.asahi.com/national/update/1110/OSK200911100070.html",
      "http://www.asahi.com/politics/update/1110/TKY200911100262.html",
      "http://www.asahi.com/national/update/1110/TKY200911100205.html",
    ].to_enum(:each_with_index).map { |url, index| "url#{index + 1}=" + CGI.escape(url) }.join("&")
    path = "/hatena-bookmark/get-title"

    response = http_post(path, data)
    assert_equal(200, response.code.to_i)

    expected = {
      "1" => {
        "url"   => "http://www.asahi.com/national/update/1110/TKY200911100156.html",
        "title" => "asahi.com（朝日新聞社）：茂木健一郎氏が３億数千万円申告漏れ　出演料など無申告 - 社会",
      },
      "2" => {
        "url"   => "http://www.asahi.com/national/update/1110/TKY200911100251.html",
        "title" => "asahi.com（朝日新聞社）：公然わいせつの疑い、篠山紀信さんの事務所など家宅捜索 - 社会",
      },
      "3" => {
        "url"   => "http://www.asahi.com/national/update/1110/TKY200911100106.html",
        "title" => "asahi.com（朝日新聞社）：喫煙率、過去最低　男性３６．８％、２０歳代が大幅減 - 社会",
      },
      "4" => {
        "url"   => "http://www.asahi.com/sports/update/1110/TKY200911100172.html",
        "title" => "asahi.com（朝日新聞社）：ヤンキース・松井秀がＦＡ申請 - スポーツ",
      },
      "5" => {
        "url"   => "http://www.asahi.com/national/update/1110/SEB200911100004.html",
        "title" => "asahi.com（朝日新聞社）：道仁会本部、系列組事務所に移転　福岡県公安委が公示 - 社会",
      },
      "6" => {
        "url"   => "http://www.asahi.com/international/update/1110/TKY200911100277.html",
        "title" => "asahi.com（朝日新聞社）：タクシン氏、カンボジア入り　タイ政府は反発 - 国際",
      },
      "7" => {
        "url"   => "http://www.asahi.com/national/update/1110/NGY200911100005.html",
        "title" => "asahi.com（朝日新聞社）：名古屋駅前でミキサー車が横転、生コン飛び出す - 社会",
      },
      "8" => {
        "url"   => "http://www.asahi.com/national/update/1110/OSK200911100070.html",
        "title" => "asahi.com（朝日新聞社）：大阪・西成で放火容疑、男逮捕　連続不審火との関連捜査 - 社会",
      },
      "9" => {
        "url"   => "http://www.asahi.com/politics/update/1110/TKY200911100262.html",
        "title" => "asahi.com（朝日新聞社）：鳩山家資産管理会社からの引き出し「年平均５千万円」 - 政治",
      },
      "10" => {
        "url"   => "http://www.asahi.com/national/update/1110/TKY200911100205.html",
        "title" => "asahi.com（朝日新聞社）：中央線が再開　阿佐ケ谷で人身事故、一時運転見合わせ - 社会",
      },
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
