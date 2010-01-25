#! ruby -Ku

require "test/unit"
require "rubygems"
require "win32console" if RUBY_PLATFORM =~ /win32/
require "redgreen"
require "facets"

require "google_news"

class GoogleNewsTest < Test::Unit::TestCase
  def setup
    @module = GoogleNews
  end

  def test_create_params
    expected = {
      "hl"     => "ja",
      "ned"    => "us",
      "ie"     => "UTF-8",
      "oe"     => "UTF-8",
      "output" => "rss",
      "num"    => "10",
      "q"      => "keyword",
    }
    assert_equal(
      expected,
      @module.create_params(:keyword => "keyword"))
  end

  def test_create_params__keyword
    assert_equal(
      "foo",
      @module.create_params(:keyword => "foo")["q"])
  end

  def test_create_params__num
    assert_equal(
      "20",
      @module.create_params(:keyword => "foo", :num => 20)["num"])
  end

  def test_create_params__no_keyword
    assert_raise(ArgumentError) {
      @module.create_params()
    }
  end

  def test_create_params__invalid_param
    assert_raise(ArgumentError) {
      @module.create_params(:keyword => "keyword", :invalid => true)
    }
  end

  def test_create_base_url
    assert_equal(
      "http://news.google.com/news",
      @module.create_base_url())
  end

  def test_encode_params
    assert_equal(
      "a=1&b=2&c=3",
      @module.encode_params("a" => "1", "b" => "2", "c" => "3"))
  end

  def test_encode_params__encode
    assert_equal(
      "+=+",
      @module.encode_params(" " => " "))
  end

  def test_create_url
    assert_equal(
      "http://news.google.com/news?hl=ja&ie=UTF-8&ned=us&num=10&oe=UTF-8&output=rss&q=keyword",
      @module.create_url(:keyword => "keyword"))
  end

  def test_create_url__keyword
    assert_equal(
      "http://news.google.com/news?hl=ja&ie=UTF-8&ned=us&num=10&oe=UTF-8&output=rss&q=foo",
      @module.create_url(:keyword => "foo"))
  end

  def test_create_url__num
    assert_equal(
      "http://news.google.com/news?hl=ja&ie=UTF-8&ned=us&num=20&oe=UTF-8&output=rss&q=foo",
      @module.create_url(:keyword => "foo", :num => 20))
  end

  def test_create_url__no_keyword
    assert_raise(ArgumentError) {
      @module.create_url()
    }
  end

  def test_create_url__invalid_param
    assert_raise(ArgumentError) {
      @module.create_url(:keyword => "keyword", :invalid => true)
    }
  end

  def test_fetch_url
    assert_kind_of(
      String,
      @module.fetch_url("http://www.google.co.jp/"))
  end

  def test_fetch_url__not_found
    assert_equal(nil, @module.fetch_url("http://www.google.co.jp/notfound"))
  end

  def test_parse_rss
    rss = File.open("#{__DIR__}/google_news.xml", "rb") { |file| file.read }

    items = @module.parse_rss(rss)

    assert_equal(10, items.size)
    assert_equal(true, items.all? { |h| h.has_key?(:title) })
    assert_equal(true, items.all? { |h| h.has_key?(:url) })

    assert_equal(
      "＜東証＞鉄道株が小幅高 ＪＰモルガン系の投信設定で思惑 - 日本経済新聞",
      items[0][:title])
    assert_equal(
      "http://markets.nikkei.co.jp/kokunai/chumoku.aspx?id=ASFL25047%2025012010",
      items[0][:url])
  end

  def test_search
    items = @module.search(:keyword => "鉄道", :num => 10)

    assert_equal(10, items.size)
    assert_equal(true, items.all? { |h| h.has_key?(:title) })
    assert_equal(true, items.all? { |h| h.has_key?(:url) })
  end
end
