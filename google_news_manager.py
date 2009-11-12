# -*- coding: utf-8 -*-

import logging
import sha
from google.appengine.api import memcache
from google.appengine.api import urlfetch

from google_news import GoogleNews

class GoogleNewsManager:
  def __init__(self):
    self.ttl = 60 * 5 # 5 minutes

  def create_key(self, keyword, num):
    return "google_news_" + sha.sha(keyword.encode("utf-8")).hexdigest() + "_" + str(num)

  def search(self, keyword, num):
    key   = self.create_key(keyword, num)
    value = memcache.get(key)
    if value is None:
      # MEMO: 1度だけ再試行する
      try:
        value = GoogleNews.search(keyword, num)
      except urlfetch.DownloadError:
        logging.info("retry download")
        value = GoogleNews.search(keyword, num)
      memcache.add(key, value, self.ttl)
    return value
