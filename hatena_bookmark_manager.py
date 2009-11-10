# -*- coding: utf-8 -*-

import sha
import logging
import re
from google.appengine.api import memcache
from BeautifulSoup import BeautifulSoup

from hatena_bookmark import HatenaBookmark

class HatenaBookmarkManager:
  def __init__(self):
    pass

  def get_title(self, url):
    fetcher = TitleFetcher()
    return fetcher.fetch_title(url)

  def get_summary(self, url):
    entry_url = HatenaBookmark.create_entry_url(url)
    src = HatenaBookmark.fetch_url(entry_url)
    src = HatenaBookmark.trim_script_tag(src)
    return HatenaBookmark.extract_summary(src)

class TitleFetcher:
  def __init__(self):
    username, password = HatenaBookmark.read_credential()
    self.hatena_bm = HatenaBookmark(username, password)
    self.ttl = 60 * 60

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
      memcache.add(key, title, self.ttl)
      return title

  def create_key(self, url):
    return "hatena_bookmark_title_" + sha.sha(url).hexdigest()
