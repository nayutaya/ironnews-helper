# -*- coding: utf-8 -*-

import sha
import logging
from google.appengine.api import memcache

from hatena_bookmark import HatenaBookmark

class HatenaBookmarkManager:
  def __init__(self):
    self.username, self.password = self.read_credential()
    self.ttl = 60 * 60

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
      value = HatenaBookmark.get_title(url, self.username, self.password)
      memcache.add(key, value, self.ttl)
    else:
      logging.info("cache hit")

    return value

  def create_title_key(self, url):
    return "hatena_bookmark_title_" + sha.sha(url).hexdigest()

  def get_summary(self, url):
    logging.info("get summary " + url)
    key = self.create_summary_key(url)
    value = memcache.get(key)

    if value is None:
      logging.info("cache miss")
      value = HatenaBookmark.get_summary(url)
      memcache.add(key, value, self.ttl)
    else:
      logging.info("cache hit")

    return value

  def create_summary_key(self, url):
    return "hatena_bookmark_summary_" + sha.sha(url).hexdigest()
