
class MemcacheMock
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
