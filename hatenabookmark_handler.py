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
    numbers  = range(1, 10 + 1)
    urls     = [self.request.get("url%i" % number) for number in numbers]
    callback = self.request.get("callback")

    fetcher = TitleFetcher()

    result = {}
    for number in numbers:
      url = urls[number - 1]
      if url != "":
        title = fetcher.fetch_title(url)
        result[number] = {
          "url"  : url,
          "title": title,
        }

    output = json.write(result)
    if callback != "":
      output = callback + "(" + output + ")"
    self.response.headers["Content-Type"] = "text/javascript"
    self.response.out.write(output)
