# -*- coding: utf-8 -*-

if __name__ == "__main__":
  import sys
  sys.path.append("lib")

import urllib
import urllib2
import re
from BeautifulSoup import BeautifulSoup

class GoogleNews:
  @classmethod
  def create_params(cls, keyword, num):
    return {
      "hl"    : "ja",
      "ned"   : "us",
      "ie"    : "UTF-8",
      "oe"    : "UTF-8",
      "output": "rss",
      "num"   : str(num),
      "q"     : keyword.encode("utf-8"),
    }

  @classmethod
  def create_url(cls, keyword, num):
    params = cls.create_params(keyword, num)
    return "http://news.google.com/news?" + urllib.urlencode(params)

  @classmethod
  def fetch_rss(cls, keyword, num):
    url = GoogleNews.create_url(keyword, num)
    request = urllib2.Request(url = url)
    request.add_header("User-Agent", "ironnews")
    io = urllib2.urlopen(request)
    try:
      return io.read()
    finally:
      io.close()

  @classmethod
  def parse_rss(cls, rss):
    pattern  = re.compile(r"cluster=(.+?)$")
    document = BeautifulSoup(rss)

    result = []
    items = document.findAll("item")
    for item in items:
      title = item.find("title").string
      guid  = item.find("guid").string

      match = re.search(pattern, guid)
      url   = match.group(1).replace("&amp;", "&")
      result.append({
        "title": title,
        "url"  : url,
      })

    return result

  @classmethod
  def search(cls, keyword, num):
    rss   = GoogleNews.fetch_rss(keyword, num)
    items = GoogleNews.parse_rss(rss)
    return items


if __name__ == "__main__":
  items = GoogleNews.search(u"鉄道", 20)
  for item in items:
    print "---"
    print item["url"]
    print item["title"]
