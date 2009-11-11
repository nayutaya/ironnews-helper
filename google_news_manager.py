# -*- coding: utf-8 -*-

import logging
import sha
from google.appengine.api import memcache

from google_news import GoogleNews

class GoogleNewsManager:
  def __init__(self):
    self.ttl = 60 * 60 # 1 hour

  def create_key(self, keyword, num):
    return "google_news_" + sha.sha(keyword.encode("utf-8")).hexdigest() + "_" + str(num)

  def search(self, keyword, num):
    key   = self.create_key(keyword, num)
    value = memcache.get(key)
    if value is None:
      value = GoogleNews.search(keyword, num)
      memcache.add(key, value, self.ttl)
    return value
