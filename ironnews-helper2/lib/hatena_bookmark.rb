
require "digest/sha1"
require "hpricot"
require "appengine-apis/memcache"
require "lib/memcache_base64"

# FIXME: memcacheのネームスペースを指定
module HatenaBookmark
  def self.get_memcache
    return MemcacheBase64.new(AppEngine::Memcache.new(:namespace => "hatena_bookmark"))
  end

  def self.get_entry_url(url)
    return url.sub(/^http:\/\//, "http://b.hatena.ne.jp/entry/")
  end

  # FIXME: エラー処理
  def self.fetch_page(url, options = {})
    timeout = options[:timeout] || 5
    response = AppEngine::URLFetch.fetch(url, :deadline => timeout)
    return response.body
  end

  def self.get_page(url, options = {})
    timeout = options[:timeout]
    expire  = options[:expire] || 10 # sec

    # MEMO: なぜかキャッシュが失効しないので、キーに時刻を含めることで対処する
    time = Time.now.to_i / expire
    key  = "get_page_#{Digest::SHA1.hexdigest(url)}_#{time}"

    memcache = self.get_memcache
    value    = memcache.get(key)
    unless value
      value = self.fetch_page(url, :timeout => 10)
      memcache.set(key, value, expire)
    end

    return value
  end

  def self.get_entry_page(url)
    entry_url = self.get_entry_url(url)
    page      = self.get_page(entry_url, :timeout => 10, :expire => 10)
    return page
  end

  def self.get_pref_without_cache(url)
    body = self.get_entry_page(url)
    doc  = Hpricot.parse(body)       if body
    div  = doc.at("#entryinfo-body") if doc
    link = div.at("a.location-link") if div
    pref = link.inner_text           if link
    return pref
  end

  def self.get_pref(url)
    expire = 10 # sec

    # MEMO: なぜかキャッシュが失効しないので、キーに時刻を含めることで対処する
    time = Time.now.to_i / expire
    key  = "get_pref_#{Digest::SHA1.hexdigest(url)}_#{time}"

    memcache = self.get_memcache
    value    = memcache.get(key)
    unless value
      value = self.get_pref_without_cache(url)
      memcache.set(key, value, expire)
    end

    return value
  end
end
