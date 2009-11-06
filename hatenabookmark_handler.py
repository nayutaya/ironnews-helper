# -*- coding: utf-8 -*-

import sha
import logging
from google.appengine.ext import webapp
from google.appengine.api import memcache

import json
from BeautifulSoup import BeautifulSoup

from hatenabookmark import HatenaBookmark

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

class GetTitleApi(webapp.RequestHandler):
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

    self.response.headers["Content-Type"] = "text/javascript"
    self.response.out.write(json.write(result))
