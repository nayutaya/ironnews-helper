
class MemcacheLimited
  def initialize(memcache, expiration)
    @memcache   = memcache
    @expiration = expiration
  end

  attr_reader :memcache, :expiration

  def create_key(key)
    return "#{key}_#{Time.now.to_i / @expiration * @expiration}"
  end

  def get(key)
    return @memcache.get(self.create_key(key))
  end

  def set(key, value, expiration = 0)
    return @memcache.set(self.create_key(key), value, expiration)
  end
end
