# -*- coding: utf-8 -*-

import urllib
import urllib2

class GoogleNews:
  @classmethod
  def create_params(cls, keyword):
    return {
      "hl"    : "ja",
      "ned"   : "us",
      "ie"    : "UTF-8",
      "oe"    : "UTF-8",
      "output": "rss",
      "q"     : keyword.encode("utf-8"),
    }

  @classmethod
  def create_url(cls, keyword):
    params = cls.create_params(keyword)
    return "http://news.google.com/news?" + urllib.urlencode(params)

  @classmethod
  def fetch_rss(cls, keyword):
    url = GoogleNews.create_url(keyword)
    request = urllib2.Request(url = url)
    request.add_header("User-Agent", "ironnews")
    io = urllib2.urlopen(request)
    try:
      return io.read()
    finally:
      io.close()

src = GoogleNews.fetch_rss(u"鉄道")
print src
