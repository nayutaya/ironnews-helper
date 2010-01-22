#! ruby -Ku

require "test/unit"
require "rubygems"
require "kagemusha"
require "memcache_mock"
require "memcache_limited"

class MemcacheLimitedTest < Test::Unit::TestCase
  def setup
    @klass = MemcacheLimited
    @obj   = @klass.new(MemcacheMock.new)

    @time_musha = Kagemusha.new(Time)
  end

  def test_initialize
    assert_kind_of(
      MemcacheMock,
      @klass.new(MemcacheMock.new).memcache)
  end

  def test_get
    assert_equal(nil, @obj.get("foo"))
    @obj.memcache.store["foo_0"] = "ABC"

    @time_musha.def(:to_i) { 0 }
    @time_musha.swap {
      assert_equal("ABC", @obj.get("foo"))
    }
  end

  def test_set
    assert_equal(nil, @obj.memcache.store["foo_0"])

    @time_musha.def(:to_i) { 0 }
    @time_musha.swap {
      @obj.set("foo", "ABC")
    }

    assert_equal("ABC", @obj.memcache.store["foo_0"])
  end
end
