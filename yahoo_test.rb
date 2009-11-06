#! ruby -Ku

require "cgi"
require "open-uri"
require "pp"

require "rubygems"
require "json"

texts = []
texts << "２６日午後７時４０分ごろ、京都府長岡京市長岡の阪急京都線の踏切近くで、線路上にいた同市に住む男性（２９）が、河原町発梅田行き準急電車にはねられ、全身を強く打って即死した。運転士が警笛を鳴らしても退避しなかったといい、向日町署は自殺の可能性があるとみて調べている。　阪急によると、この電車は現場に８分間停車。後続など上下計２９本が３〜７分遅れとなり、約１万２５００人に影響した。"
#texts << "民主党の山岡賢次国会対策委員長は６日、在日韓国・朝鮮人を中心とする永住外国人に地方参政権を付与する法案を、議員立法で今国会に提出する意向を示した。国会内で記者団に語った。永住外国人への地方参政権付与は民主党の小沢一郎幹事長の持論で、公明党も前向きだ。山岡氏は民主党の一部や自民党の根強い反対論に配慮し、採決時に党議拘束を外すことも検討していることを明らかにした。"
#texts << "６日午前０時すぎ、ＪＲ横浜線の十日市場―中山駅間の踏切（横浜市緑区三保町）で乗用車と上り列車が衝突した。ＪＲ東日本横浜支社によると、午前１時現在、東神奈川―橋本駅間の上下線で運転を見合わせている。"
#texts << "ＪＲ宝塚線（福知山線）脱線事故で、業務上過失致死傷容疑で告訴され不起訴処分になったＪＲ西日本の歴代社長３人について、遺族らでつくる「４・２５ネットワーク」は４日、起訴するよう神戸地検に申し入れた。"

params = texts.to_enum(:each_with_index).map { |text, index|
  "text#{index + 1}=#{CGI.escape(text)}"
}

url  = "http://localhost:8080/yahoo-keyphrase/extract?" + params.join("&")
json = open(url) { |io| io.read }
obj  = JSON.parse(json)
pp obj