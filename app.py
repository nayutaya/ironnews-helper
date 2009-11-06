# -*- coding: utf-8 -*-

import sys
import os
import logging
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.ext.webapp import template
from google.appengine.api import memcache

sys.path.append("lib")
from BeautifulSoup import BeautifulSoup
import json

from hatenabookmark import HatenaBookmark



import sha
class TitleFetcher:
  def __init__(self):
    username, password = HatenaBookmark.read_credential()
    self.hatena_bm = HatenaBookmark(username, password)

  def fetch_title(self, url):
    logging.info("get title: " + url)
    key = self.create_key(url)
    logging.info("key: " + key)

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

class HatenaBookmarkGetTitleApi(webapp.RequestHandler):
  def get(self):
    fetcher = TitleFetcher()

    result = {}
    for i in range(10):
      number = i + 1
      url    = self.request.get("url%i" % number)

      if url != "":
        title = fetcher.fetch_title(url)
        result[number] = {
          "url": url,
          "title": title,
        }

    self.response.out.write(json.write(result))

if __name__ == "__main__":
  application = webapp.WSGIApplication(
    [
      (r"/hatena/bookmark/get_title", HatenaBookmarkGetTitleApi),
    ],
    debug = True)
  run_wsgi_app(application)
