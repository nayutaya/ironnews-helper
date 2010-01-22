
class MemcacheLimited
  def initialize(memcache)
    @memcache = memcache
  end

  attr_reader :memcache

  def get(key)
    key2 = "#{key}_#{Time.now.to_i}"
    return @memcache.get(key2)
  end

  def set(key, value, expiration = 0)
    key2 = "#{key}_#{Time.now.to_i}"
    @memcache.set(key2, value, expiration)
    return true
  end
end
