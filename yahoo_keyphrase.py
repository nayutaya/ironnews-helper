# -*- coding: utf-8 -*-

import urllib
import urllib2
import simplejson

class YahooKeyphrase:
  @classmethod
  def create_base_url(cls):
    return "http://jlp.yahooapis.jp/KeyphraseService/V1/extract"

  @classmethod
  def create_url_params(cls, app_id, text):
    return {
      "appid"   : app_id,
      "sentence": text.encode("utf-8"),
      "output"  : "json",
    }

  @classmethod
  def read_url(cls, url, data):
    io = urllib2.urlopen(url, data)
    try:
      return io.read()
    finally:
      io.close()

  @classmethod
  def extract(cls, app_id, text):
    url    = cls.create_base_url()
    params = cls.create_url_params(app_id, text)
    json = cls.read_url(url, urllib.urlencode(params))
    obj  = simplejson.loads(json)
    return obj
