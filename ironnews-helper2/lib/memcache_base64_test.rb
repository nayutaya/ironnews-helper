#! ruby -Ku -rubygems

$TEST_MODE = true

require "test/unit"
require "kagemusha"
require "memcache_base64"

# Mock Class
module AppEngine
  class Memcache
    def initialize
      @store = {}
    end
    attr_reader :store
    def get(key)
      return @store[key]
    end
    def set(key, value, expiration = 0)
      @store[key] = value
      return true
    end
  end
end

class MemcacheBase64Test < Test::Unit::TestCase
  def setup
    @klass = MemcacheBase64
    @obj   = @klass.new
  end

  def test_memcache
    assert_kind_of(
      AppEngine::Memcache,
      @obj.memcache)
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
end
