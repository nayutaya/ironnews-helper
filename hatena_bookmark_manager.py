# -*- coding: utf-8 -*-

import sha
import logging
import re
from google.appengine.api import memcache
from BeautifulSoup import BeautifulSoup

from hatena_bookmark import HatenaBookmark

class HatenaBookmarkManager:
  def __init__(self):
    self.username, self.password = self.read_credential()
    self.ttl = 60 * 60

    self.hatena_bm = HatenaBookmark(self.username, self.password)

  def read_credential(self):
    f = open("config/hatena.id")
    try:
      username = f.readline().strip()
      password = f.readline().strip()
      return (username, password)
    finally:
      f.close()

  def get_title(self, url):
    logging.info("get title: " + url)
    key   = self.create_title_key(url)
    value = memcache.get(key)

    if value is None:
      logging.info("cache miss")
      response = self.hatena_bm.post(url)
      xml      = response.read()
      doc      = BeautifulSoup(xml)
      value    = doc.find("title").string.strip()
      memcache.add(key, value, self.ttl)
    else:
      logging.info("cache hit")

    return value

  def create_title_key(self, url):
    return "hatena_bookmark_title_" + sha.sha(url).hexdigest()

  def get_summary(self, url):
    return HatenaBookmark.get_summary(url)
