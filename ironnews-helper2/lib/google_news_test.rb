#! ruby -Ku

require "test/unit"
require "rubygems"
require "win32console" if RUBY_PLATFORM =~ /win32/
require "redgreen"

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
end
