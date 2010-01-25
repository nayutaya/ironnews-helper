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
end
