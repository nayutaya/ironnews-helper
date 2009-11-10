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
    @extract_path = "/yahoo-keyphrase/extract"
  end

  def test_extract__1__by_get
    text1 = "２６日午後７時４０分ごろ、京都府長岡京市長岡の阪急京都線の踏切近くで、線路上にいた同市に住む男性（２９）が、河原町発梅田行き準急電車にはねられ、全身を強く打って即死した。運転士が警笛を鳴らしても退避しなかったといい、向日町署は自殺の可能性があるとみて調べている。　阪急によると、この電車は現場に８分間停車。後続など上下計２９本が３〜７分遅れとなり、約１万２５００人に影響した。"
    data  = "text1=" + CGI.escape(text1)

    response = http_get(@extract_path, data)
    assert_equal(200, response.code.to_i)

    expected = {
      "1" => {
        "text"      => "２６日午後７時４０分ごろ、京都府長岡京市長岡の阪急京都線の踏切近くで、線路上にいた同市に住む男性（２９）が、河原町発梅田行き準急電車にはねられ、全身を強く打って即死した。運転士が警笛を鳴らしても退避しなかったといい、向日町署は自殺の可能性があるとみて調べている。　阪急によると、この電車は現場に８分間停車。後続など上下計２９本が３〜７分遅れとなり、約１万２５００人に影響した。",
        "keyphrase" => {
          "向日町署"=>79,"8分間停車"=>42,"河原町発梅田行き準急"=>80,"後続"=>54,"線路上"=>42,
          "上下"=>42,"踏切近く"=>54,"阪急"=>82,"男性"=>32,"可能性"=>38,
          "現場"=>36,"自殺"=>43,"同市"=>53,"警笛"=>67,"阪急京都線"=>56,
          "運転士"=>72,"京都府長岡京市長岡"=>100,"即死"=>53,"全身"=>39,"退避"=>61,
        },
      }
    }
    assert_equal(expected, JSON.parse(response.body))
  end

  def test_extract__1__by_post
    text1 = "民主党の山岡賢次国会対策委員長は６日、在日韓国・朝鮮人を中心とする永住外国人に地方参政権を付与する法案を、議員立法で今国会に提出する意向を示した。国会内で記者団に語った。永住外国人への地方参政権付与は民主党の小沢一郎幹事長の持論で、公明党も前向きだ。山岡氏は民主党の一部や自民党の根強い反対論に配慮し、採決時に党議拘束を外すことも検討していることを明らかにした。"
    data  = "text1=" + CGI.escape(text1)

    response = http_post(@extract_path, data)
    assert_equal(200, response.code.to_i)

    expected = {
      "1" => {
        "text"      => "民主党の山岡賢次国会対策委員長は６日、在日韓国・朝鮮人を中心とする永住外国人に地方参政権を付与する法案を、議員立法で今国会に提出する意向を示した。国会内で記者団に語った。永住外国人への地方参政権付与は民主党の小沢一郎幹事長の持論で、公明党も前向きだ。山岡氏は民主党の一部や自民党の根強い反対論に配慮し、採決時に党議拘束を外すことも検討していることを明らかにした。",
        "keyphrase" => {
          "小沢一郎幹事長"=>45,"意向"=>31,"永住外国人"=>81,"山岡賢次国会対策委員長"=>60,"議員立法"=>44,
          "在日韓国"=>37,"記者団"=>32,"朝鮮人"=>43,"地方参政権付与"=>52,"採決時"=>65,
          "持論"=>36,"山岡"=>100,"民主党"=>72,"今国会"=>48,"公明党"=>41,
          "前向き"=>32,"根強い反対論"=>61,"自民党"=>34,"党議拘束"=>54,"地方参政権"=>77,
        },
      }
    }
    assert_equal(expected, JSON.parse(response.body))
  end

  private

  def http_get(path, data = nil)
    path += "?" + data if data
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

=begin
#texts << "６日午前０時すぎ、ＪＲ横浜線の十日市場―中山駅間の踏切（横浜市緑区三保町）で乗用車と上り列車が衝突した。ＪＲ東日本横浜支社によると、午前１時現在、東神奈川―橋本駅間の上下線で運転を見合わせている。"
#texts << "ＪＲ宝塚線（福知山線）脱線事故で、業務上過失致死傷容疑で告訴され不起訴処分になったＪＲ西日本の歴代社長３人について、遺族らでつくる「４・２５ネットワーク」は４日、起訴するよう神戸地検に申し入れた。"
=end
