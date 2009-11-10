# -*- coding: utf-8 -*-

import sha
from google.appengine.ext import webapp
from google.appengine.api import memcache

import simplejson

import yahoo

class YahooKeyphrase:
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

class ExtractApi(webapp.RequestHandler):
  def get(self):
    self.process()

  def post(self):
    self.process()

  def process(self):
    numbers  = range(1, 10 + 1)
    texts    = [self.request.get("text%i" % number) for number in numbers]
    callback = self.request.get("callback")

    yk = YahooKeyphrase()

    result = {}
    for number in numbers:
      text = texts[number - 1]
      if text == "": continue

      keyphrase = yk.extract(text)
      result[number] = {
        "text"     : text,
        "keyphrase": keyphrase,
      }

    json = simplejson.dumps(result, separators=(',',':'))
    if callback != "": json = callback + "(" + json + ")"
    self.response.headers["Content-Type"] = "text/javascript"
    self.response.out.write(json)
