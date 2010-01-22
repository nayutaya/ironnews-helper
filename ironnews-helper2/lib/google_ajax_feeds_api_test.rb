#! ruby -Ku

require "test/unit"
require "google_ajax_feeds_api"

#  url = "http://ajax.googleapis.com/ajax/services/feed/load?q=http%3a%2f%2fwww3%2easahi%2ecom%2frss%2findex%2erdf&v=1.0&output=json&num=20"

class GoogleAjaxFeedsApiTest < Test::Unit::TestCase
  def setup
    @module = GoogleAjaxFeedsApi
  end

  def test_create_parameter__minimal
    expected = {
      "v"      => "1.0",
      "output" => "json",
      "q"      => "http://example.jp/",
      "num"    => "10",
    }
    assert_equal(
      expected,
      @module.create_parameter(:url => "http://example.jp/"))
  end

  def test_create_parameter__full
    expected = {
      "v"      => "1.0",
      "output" => "json",
      "q"      => "http://example.jp/",
      "num"    => "20",
    }
    assert_equal(
      expected,
      @module.create_parameter(
        :url => "http://example.jp/",
        :num => 20))
  end

  def test_create_parameter__no_url
    assert_raise(ArgumentError) {
      @module.create_parameter()
    }
  end

  def test_create_parameter__invalid_parameter
    assert_raise(ArgumentError) {
      @module.create_parameter(:invalid => true)
    }
  end

  def test_create_base_url
    assert_equal(
      "http://ajax.googleapis.com/ajax/services/feed/load",
      @module.create_base_url())
  end

  def test_create_url
    assert_equal(
      "http://ajax.googleapis.com/ajax/services/feed/load?num=10&output=json&q=http%3A%2F%2Fexample.jp%2F&v=1.0",
      @module.create_url(:url => "http://example.jp/"))
    assert_equal(
      "http://ajax.googleapis.com/ajax/services/feed/load?num=20&output=json&q=http%3A%2F%2Fexample.jp%2F&v=1.0",
      @module.create_url(:url => "http://example.jp/", :num => 20))
  end

  def test_create_url__invalid_parameter
    assert_raise(ArgumentError) {
      @module.create_url(:invalid => true)
    }
  end
end
