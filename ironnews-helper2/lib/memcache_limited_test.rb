#! ruby -Ku

require "test/unit"
require "rubygems"
require "kagemusha"
require "memcache_mock"
require "memcache_limited"

class MemcacheLimitedTest < Test::Unit::TestCase
  def setup
    @klass = MemcacheLimited
    @obj   = @klass.new(MemcacheMock.new, 10)

    @time_musha = Kagemusha.new(Time)
  end

  def test_initialize
    obj = @klass.new(MemcacheMock.new, 20)
    assert_kind_of(MemcacheMock, obj.memcache)
    assert_equal(20, obj.expiration)
  end

  def test_create_key__expiration10
    obj= @klass.new(MemcacheMock.new, 10)
    @time_musha.def(:to_i) { 0 }
    @time_musha.swap { assert_equal("foo_0", obj.create_key("foo")) }
    @time_musha.def(:to_i) { 9 }
    @time_musha.swap { assert_equal("foo_0", obj.create_key("foo")) }
    @time_musha.def(:to_i) { 10 }
    @time_musha.swap { assert_equal("foo_10", obj.create_key("foo")) }
    @time_musha.def(:to_i) { 19 }
    @time_musha.swap { assert_equal("foo_10", obj.create_key("foo")) }
    @time_musha.def(:to_i) { 20 }
    @time_musha.swap { assert_equal("foo_20", obj.create_key("foo")) }
  end

  def test_create_key__expiration5
    obj= @klass.new(MemcacheMock.new, 5)
    @time_musha.def(:to_i) { 0 }
    @time_musha.swap { assert_equal("foo_0", obj.create_key("foo")) }
    @time_musha.def(:to_i) { 4 }
    @time_musha.swap { assert_equal("foo_0", obj.create_key("foo")) }
    @time_musha.def(:to_i) { 5 }
    @time_musha.swap { assert_equal("foo_5", obj.create_key("foo")) }
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

  def test_set_and_get
    @time_musha.def(:to_i) { 0 }
    @time_musha.swap {
      @obj.set("foo", "ふー")
      assert_equal("ふー", @obj.get("foo"))
    }

    @time_musha.def(:to_i) { 9 }
    @time_musha.swap {
      assert_equal("ふー", @obj.get("foo"))
      @obj.set("bar", "ばー")
      assert_equal("ばー", @obj.get("bar"))
    }

    @time_musha.def(:to_i) { 10 }
    @time_musha.swap {
      assert_equal(nil, @obj.get("foo"))
      assert_equal(nil, @obj.get("bar"))
    }
  end
end
