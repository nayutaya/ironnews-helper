# -*- coding: utf-8 -*-

import urllib
import urllib2

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

src = GoogleNews.fetch_rss(u"鉄道", 20)
#print src

f = open("out.xml", "w")
f.write(src)
f.close()

import sys
sys.path.append("lib")

from BeautifulSoup import BeautifulSoup

document = BeautifulSoup(src)
items = document.findAll("item")

import re

pattern = re.compile(r"cluster=(.+?)$")

for item in items:
  title = item.find("title").string
  guid  = item.find("guid").string

  print "---"
  #print item
  print title
  #print guid

  match = re.search(pattern, guid)
  print match.group(1)
