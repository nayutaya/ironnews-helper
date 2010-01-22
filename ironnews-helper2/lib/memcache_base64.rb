
require "base64"
require "appengine-apis/memcache" unless $TEST_MODE

# MEMO: なぜかキャッシュすると文字化けするため、BASE64エンコード/デコードして対処する
class MemcacheBase64
  def initialize
    @memcache = AppEngine::Memcache.new
  end

  attr_reader :memcache

  def get(key)
    value64 = @memcache.get(key)
    return nil unless value64
    return Base64.decode64(value64)
  end

  def set(key, value, expiration = 0)
    value64 = Base64.encode64(value)
    return @memcache.set(key, value64, expiration)
  end
end
