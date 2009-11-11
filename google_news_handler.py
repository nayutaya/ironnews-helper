# -*- coding: utf-8 -*-

import logging
import simplejson
from google.appengine.ext import webapp

from google_news_manager import GoogleNewsManager

class SearchApi(webapp.RequestHandler):
  def get(self):
    keyword  = self.request.get("keyword")
    num      = self.request.get("num", default_value = "10")
    callback = self.request.get("callback")

    news_manager = GoogleNewsManager()
    result = news_manager.search(keyword, int(num))

    json = simplejson.dumps(result, separators=(',',':'))
    if callback != "": json = callback + "(" + json + ")"
    self.response.headers["Content-Type"] = "text/javascript"
    self.response.out.write(json)
