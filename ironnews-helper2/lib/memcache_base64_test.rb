#! ruby -Ku

require "test/unit"
require "rubygems"
require "kagemusha"
require "memcache_mock"
require "memcache_base64"

class MemcacheBase64Test < Test::Unit::TestCase
  def setup
    @klass = MemcacheBase64
    @obj   = @klass.new(MemcacheMock.new)
  end

  def test_initialize
    obj = @klass.new(MemcacheMock.new)
    assert_kind_of(MemcacheMock, obj.memcache)
  end

  def test_get
    assert_equal(nil, @obj.get("foo"))
    @obj.memcache.store["foo"] = "QUJD\n"
    assert_equal("ABC", @obj.get("foo"))
  end

  def test_set
    assert_equal(nil, @obj.memcache.store["foo"])
    @obj.set("foo", "ABC")
    assert_equal("QUJD\n", @obj.memcache.store["foo"])
  end

  def test_set_and_get
    assert_equal(nil, @obj.get("foo"))
    @obj.set("foo", "ふー")
    assert_equal("ふー", @obj.get("foo"))

    assert_equal(nil, @obj.get("bar"))
    @obj.set("bar", "ばー")
    assert_equal("ばー", @obj.get("bar"))
  end
end
