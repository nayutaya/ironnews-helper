#! ruby -Ku

require "test/unit"
require "cgi"
require "net/http"
require "rubygems"
require "json"

class HatenaBookmarkTest < Test::Unit::TestCase
  def setup
    if true
      @host = "localhost"
      @port = 8080
    else
      @host = "v3.latest.ironnews-helper2.appspot.com"
      @port = 80
    end

    @get_title_path   = "/hatena-bookmark/get-title"
    @get_summary_path = "/hatena-bookmark/get-summary"
  end

  def test_get_title__1__by_get
    data = "url1=" + CGI.escape("http://www.asahi.com/international/update/1110/TKY200911100249.html")

    response = http_get(@get_title_path, data)
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
    data = "url1=" + CGI.escape("http://www.asahi.com/national/update/1110/SEB200911100003.html")

    response = http_post(@get_title_path, data)
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

    response = http_post(@get_title_path, data)
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

  def test_get_summary__1__by_get
    data = "url1=" + CGI.escape("http://www.asahi.com/international/update/1110/TKY200911100249.html")

    response = http_get(@get_summary_path, data)
    assert_equal(200, response.code.to_i)

    expected = {
      "1" => {
        "url"     => "http://www.asahi.com/international/update/1110/TKY200911100249.html",
        "title"   => "asahi.com（朝日新聞社）：韓国と北朝鮮の海軍、黄海で一時交戦　聯合ニュース報道 - 国際",
        "summary" => "【ソウル＝箱田哲也】韓国の聯合ニュースは１０日、朝鮮半島西方の黄海で同日午前、韓国と北朝鮮の海軍が一時的に交戦状態になった、と伝えた。韓国側の死傷者については明らかになっていない。",
      },
    }
    assert_equal(expected, JSON.parse(response.body))
  end

  def test_get_summary__1__by_post
    data = "url1=" + CGI.escape("http://www.asahi.com/national/update/1110/SEB200911100003.html")

    response = http_post(@get_summary_path, data)
    assert_equal(200, response.code.to_i)

    expected = {
      "1" => {
        "url"     => "http://www.asahi.com/national/update/1110/SEB200911100003.html",
        "title"   => "asahi.com（朝日新聞社）：沖縄のひき逃げ事件、米側が陸軍兵の身柄を確保 - 社会",
        "summary" => "沖縄県読谷村でひき逃げされたとみられる男性の遺体が見つかった事件で、在沖米陸軍のウッダード司令官は１０日、読谷村の安田慶造村長と面会し、車を運転していた陸軍兵を特定し、同村の陸軍トリイ通信施設内で身柄を確保していると説明した。日米地位協定では、容疑者の身柄が米側にある場合、日本側が起訴するまで、米側が身柄を拘束することになっている。同司令官は村長に対し、「現段階では日本側から身柄の引き渡し要請はないが、正式な話があればきちんと対応したい」と話したという。 　一方、沖縄県警は１０日、同村内のマンションに...",
      },
    }
    assert_equal(expected, JSON.parse(response.body))
  end

  def test_get_summary__10__by_post
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

    response = http_post(@get_summary_path, data)
    assert_equal(200, response.code.to_i)

    expected = {
      "1" => {
        "url"     => "http://www.asahi.com/national/update/1110/TKY200911100156.html",
        "title"   => "asahi.com（朝日新聞社）：茂木健一郎氏が３億数千万円申告漏れ　出演料など無申告 - 社会",
        "summary" => "脳科学者の茂木健一郎氏（４７）が、東京国税局から３億数千万円の申告漏れを指摘されていたことが分かった。０８年までの３年間に得たテレビの出演料や著書の印税などを全く申告していなかった。無申告加算税を含む追徴税額は１億数千万円で、茂木氏は既に申告に応じて納税も一部済ませているという。 　茂木氏は「ソニーコンピュータサイエンス研究所」（東京）に勤務しながら、講演や執筆活動、テレビ番組の出演などもしている。同研究所の親会社のソニーは「これからはきちんと申告するよう指導した」としている。 　茂木氏が同研究所から得た...",
      },
      "2" => {
        "url"     => "http://www.asahi.com/national/update/1110/TKY200911100251.html",
        "title"   => "asahi.com（朝日新聞社）：公然わいせつの疑い、篠山紀信さんの事務所など家宅捜索 - 社会",
        "summary" => "写真家の篠山紀信氏の写真集「２０ＸＸＴＯＫＹＯ」（朝日出版社刊）のロケで、東京都港区の青山霊園などで女性のヌード撮影をしたのは公然わいせつの疑いがあるとして、警視庁は１０日、同区赤坂９丁目の篠山氏の個人事務所や自宅、モデルの女優の所属事務所を家宅捜索した。 　同庁によると、家宅捜索の容疑は、昨年８月中旬ごろ、誰でも見られる状態で公道や公共空間で同写真集のヌード撮影を行ったというもの。同写真集は今年１月に発行され、青山霊園や東京・お台場などの屋外で撮影した女優の全裸の写真などが掲載されている。篠山紀信事...",
      },
      "3" => {
        "url"     => "http://www.asahi.com/national/update/1110/TKY200911100106.html",
        "title"   => "asahi.com（朝日新聞社）：喫煙率、過去最低　男性３６．８％、２０歳代が大幅減 - 社会",
        "summary" => "厚生労働省が９日に公表した０８年の国民健康・栄養調査で、男性の喫煙率が３６．８％と調査開始の８６年以降で、過去最低になったことが明らかになった。女性は９．１％で０１年以来７年ぶりに１０％を下回った。厚労省生活習慣病対策室は「受動喫煙など、たばこの害に関する理解が広がった影響では」とみている。 　調査は全国約８１４９人の男女が対象。８６年当時の喫煙率は男性は５９．７％、女性は８．６％だった。 　５年前の０３年と比較すると、男性は４６．８％から１０ポイントの大幅な減少。女性は１１．３％から２．２ポイント減った...",
      },
      "4" => {
        "url"     => "http://www.asahi.com/sports/update/1110/TKY200911100172.html",
        "title"   => "asahi.com（朝日新聞社）：ヤンキース・松井秀がＦＡ申請 - スポーツ",
        "summary" => "【シカゴ＝榊原一生】大リーグのワールドシリーズで日本選手初の最優秀選手（ＭＶＰ）に輝き、今季がヤンキースとの契約最終年の松井秀喜選手（３５）が９日、フリーエージェントの申請をしたことが分かった。代理人を務めるアーン・テレム氏が明らかにした。 　ただ、１９日まではヤンキースが優先的に交渉でき、２０日以降はヤンキースを含めた全球団との交渉が可能になる。 　この日、ゼネラルマネジャー（ＧＭ）会議で当地を訪れたヤンキースのキャッシュマンＧＭは「（松井の）ＦＡ申請は自然な流れ。これから彼と話をしていくが、我々として...",
      },
      "5" => {
        "url"     => "http://www.asahi.com/national/update/1110/SEB200911100004.html",
        "title"   => "asahi.com（朝日新聞社）：道仁会本部、系列組事務所に移転　福岡県公安委が公示 - 社会",
        "summary" => "指定暴力団道仁会の本部事務所について、福岡県公安委員会は１０日、これまでの福岡県久留米市通東町から、約２キロ西にある同市京町の系列の組事務所に移転したと、官報で公示した。通東町の事務所を巡っては、福岡高裁が周辺住民の訴えを認めて使用禁止の仮処分を出し、現在使えない状態になっている。 　道仁会側も京町の事務所を本部の移転先として張り紙などで告知していたが、県警は裁判対策の可能性があるとみて動向を調査していた。その結果、通東町の事務所が使えない状態になり、売却に向けた住民側との交渉が始まったことや、京町の事務...",
      },
      "6" => {
        "url"     => "http://www.asahi.com/international/update/1110/TKY200911100277.html",
        "title"   => "asahi.com（朝日新聞社）：タクシン氏、カンボジア入り　タイ政府は反発 - 国際",
        "summary" => "プノンペンに到着したタクシン元首相＝ロイター【プノンペン＝山本大輔】カンボジア政府の経済顧問に就任したタイのタクシン元首相は１０日、プノンペンの空軍施設に空路到着した。自らの刑事裁判に反発して０８年８月にタイを出国して以来、東南アジア地域に入るのは今回が初めてとみられる。タクシン氏の顧問就任をめぐって、タイ政府は強く反発しており、両国関係がさらに悪化するのは必至だ。",
      },
      "7" => {
        "url"     => "http://www.asahi.com/national/update/1110/NGY200911100005.html",
        "title"   => "asahi.com（朝日新聞社）：名古屋駅前でミキサー車が横転、生コン飛び出す - 社会",
        "summary" => "横転したコンクリートミキサー車＝１０日午後０時２３分、名古屋市中村区、岩下毅撮影（画像の一部を修整しています） 　１０日正午ごろ、名古屋市中村区名駅４丁目の名古屋駅前ロータリーで、ミキサー車が横転した。中村署によると、運転手の男性（４６）にけがはなかった。ミキサー車から生コンクリートが飛び出し、現場は車線規制された。大勢の通行人が立ち止まり、現場は一時騒然となった。ミキサー車は同日午前に愛知県甚目寺町を出発し、現場近くの工事現場に向かう途中だったという。",
      },
      "8" => {
        "url"     => "http://www.asahi.com/national/update/1110/OSK200911100070.html",
        "title"   => "asahi.com（朝日新聞社）：大阪・西成で放火容疑、男逮捕　連続不審火との関連捜査 - 社会",
        "summary" => "大阪市西成区で段ボールに火をつけたとして、西成署は１０日、大阪市西成区玉出東２丁目、自称無職高口善行（こうぐち・よしゆき）容疑者（５８）を建造物等以外放火の疑いで逮捕し、発表した。同署によると、高口容疑者は「火をつけると燃え上がって楽しかった。他にもやった」と供述。西成区では９日未明、他にも３件の不審火があり、関連を調べている。西成署によると、高口容疑者は９日午前３時２５分ごろ、西成区玉出中１丁目の空き家の軒下にあった段ボールにライターで火をつけた疑いが持たれている。不審火が相次いでいたため署員が警戒...",
      },
      "9" => {
        "url"     => "http://www.asahi.com/politics/update/1110/TKY200911100262.html",
        "title"   => "asahi.com（朝日新聞社）：鳩山家資産管理会社からの引き出し「年平均５千万円」 - 政治",
        "summary" => "鳩山由紀夫首相は１０日の参院予算委員会で、自身の偽装献金問題に関し、元秘書が首相の了承を得て鳩山家の資産管理会社「六幸商会」の口座から引き出した金額について「年平均約５千万円だった」と述べた。「調べた範囲は６年間」だったという。自民党の西田昌司氏への答弁。 　首相は引き出し額について「私の個人としての支出も入っているし、一政治家としての支出も含まれている」と述べ、すべてが虚偽献金の原資となったわけではないと説明した。ただ、詳細な支出内容については「データは検察に渡っているので、そこで調べている」と話した。",
      },
      "10" => {
        "url"     => "http://www.asahi.com/national/update/1110/TKY200911100205.html",
        "title"   => "asahi.com（朝日新聞社）：中央線が再開　阿佐ケ谷で人身事故、一時運転見合わせ - 社会",
        "summary" => "１０日午前１１時６分ごろ、東京都杉並区阿佐谷南３丁目のＪＲ阿佐ケ谷駅で、新宿発松本行き下り特急列車「あずさ６３」号に女性が飛び込み、中央線快速の東京―高尾間、中央線各駅停車の三鷹―東京間で上下線とも約１時間にわたって運転を見合わせた。ＪＲ東によると、この事故で同線の６本が運休するなどし、約２万８千人に影響した。警視庁杉並署によると、女性は３０歳くらいで、ほぼ即死状態だったという。",
      },
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
