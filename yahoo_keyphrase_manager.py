# -*- coding: utf-8 -*-

import sha
from google.appengine.api import memcache

import yahoo

class YahooKeyphraseManager:
  def __init__(self):
    f = open("config/yahoo.id")
    try:
      self.app_id = f.readline().strip()
    finally:
      f.close()

  def create_key(self, text):
    return "yahoo_keyphrase_" + sha.sha(text.encode("utf-8")).hexdigest()

  def extract(self, text):
    key   = self.create_key(text)
    value = memcache.get(key)
    if value is None:
      value = yahoo.Keyphrase.extract(self.app_id, text)
      memcache.add(key, value, 60 * 60)
    return value
