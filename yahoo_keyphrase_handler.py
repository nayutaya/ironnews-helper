# -*- coding: utf-8 -*-

import simplejson
from google.appengine.ext import webapp

from yahoo_keyphrase_manager import YahooKeyphraseManager

class ExtractApi(webapp.RequestHandler):
  def get(self):
    self.process()

  def post(self):
    self.process()

  def process(self):
    numbers  = range(1, 10 + 1)
    texts    = [self.request.get("text%i" % number) for number in numbers]
    callback = self.request.get("callback")

    keyphrase_manager = YahooKeyphraseManager()

    result = {}
    for number in numbers:
      text = texts[number - 1]
      if text == "": continue

      keyphrase = keyphrase_manager.extract(text)
      result[number] = {
        "text"     : text,
        "keyphrase": keyphrase,
      }

    json = simplejson.dumps(result, separators=(',',':'))
    if callback != "": json = callback + "(" + json + ")"
    self.response.headers["Content-Type"] = "text/javascript"
    self.response.out.write(json)
