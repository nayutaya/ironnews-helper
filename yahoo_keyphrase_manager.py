# -*- coding: utf-8 -*-

import sha
from google.appengine.api import memcache
from google.appengine.api import urlfetch

from yahoo_keyphrase import YahooKeyphrase

class YahooKeyphraseManager:
  def __init__(self):
    self.app_id = self.read_api_id()
    self.ttl    = 60 * 60 * 24 # 1 day

  def read_api_id(self):
    f = open("config/yahoo.id")
    try:
      return f.readline().strip()
    finally:
      f.close()

  def create_key(self, text):
    return "yahoo_keyphrase_" + sha.sha(text.encode("utf-8")).hexdigest()

  def extract(self, text):
    key   = self.create_key(text)
    value = memcache.get(key)
    if value is None:
      # MEMO: 1度だけ再試行する
      try:
        value = YahooKeyphrase.extract(self.app_id, text)
      except urlfetch.DownloadError:
        logging.info("retry download")
        value = YahooKeyphrase.extract(self.app_id, text)
      memcache.add(key, value, self.ttl)
    return value
