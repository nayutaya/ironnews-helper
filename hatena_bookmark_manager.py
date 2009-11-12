# -*- coding: utf-8 -*-

import sha
import logging
from google.appengine.api import memcache
from google.appengine.api import urlfetch

from hatena_bookmark import HatenaBookmark

class HatenaBookmarkManager:
  def __init__(self):
    self.username, self.password = self.read_credential()
    self.ttl          = 60 * 60 * 24 # 1 day
    self.ttl_negative = 60 * 5       # 5 minutes

  def read_credential(self):
    f = open("config/hatena.id")
    try:
      username = f.readline().strip()
      password = f.readline().strip()
      return (username, password)
    finally:
      f.close()

  def create_title_key(self, url):
    return "hatena_bookmark_title_" + sha.sha(url).hexdigest()

  def get_title(self, url):
    key   = self.create_title_key(url)
    value = memcache.get(key)
    if value is None:
      # MEMO: 1度だけ再試行する
      try:
        value = HatenaBookmark.get_title(url, self.username, self.password)
      except urlfetch.DownloadError:
        logging.info("retry download")
        value = HatenaBookmark.get_title(url, self.username, self.password)
      memcache.add(key, value, self.ttl)
    return value

  def create_summary_key(self, url):
    return "hatena_bookmark_summary_" + sha.sha(url).hexdigest()

  def get_summary(self, url):
    key   = self.create_summary_key(url)
    value = memcache.get(key)
    if value is None:
      # MEMO: 1度だけ再試行する
      try:
        value = HatenaBookmark.get_summary(url)
      except urlfetch.DownloadError:
        logging.info("retry download")
        value = HatenaBookmark.get_summary(url)

      if value == (None, None):
        ttl = self.ttl_negative
      else:
        ttl = self.ttl

      memcache.add(key, value, ttl)
    return value
