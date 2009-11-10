# -*- coding: utf-8 -*-

import sha
import logging
import re
import urllib
import urllib2
from google.appengine.api import memcache
from BeautifulSoup import BeautifulSoup

from hatenabookmark import HatenaBookmark


class TitleFetcher:
  def __init__(self):
    username, password = HatenaBookmark.read_credential()
    self.hatena_bm = HatenaBookmark(username, password)

  def fetch_title(self, url):
    logging.info("get title: " + url)
    key = self.create_key(url)

    cache = memcache.get(key)
    if cache is not None:
      logging.info("cache hit")
      return cache
    else:
      logging.info("cache miss")
      response = self.hatena_bm.post(url)
      xml      = response.read()
      doc      = BeautifulSoup(xml)
      title    = doc.find("title").string.strip()
      memcache.add(key, title, 60 * 60)
      return title

  def create_key(self, url):
    return "hatena_bookmark_title_" + sha.sha(url).hexdigest()

def trim_script_tag(html):
  pattern = re.compile(r"<script.+?>.*?</script>", re.IGNORECASE | re.DOTALL)
  return re.sub(pattern, "", html)

def get_summary(url):
  entry_url = re.sub(re.compile(r"^http://"), "http://b.hatena.ne.jp/entry/", url)
  req = urllib2.Request(url = entry_url)
  req.add_header("User-Agent", "ironnews")
  io = urllib2.urlopen(req)
  src = io.read()
  io.close()

  src = trim_script_tag(src)
  doc = BeautifulSoup(src)

  summary = doc.find("blockquote", {"id": "entry-extract-content"})
  summary.find("cite").extract()

  return "".join([elem.string.strip() for elem in summary.findAll(text = True)])
