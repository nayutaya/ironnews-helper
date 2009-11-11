# -*- coding: utf-8 -*-

import logging
import simplejson
from google.appengine.ext import webapp
from google.appengine.api import urlfetch

from google_news_manager import GoogleNewsManager

class SearchApi(webapp.RequestHandler):
  def get(self):
    callback = self.request.get("callback")

    keyword = u"電車"
    news_manager = GoogleNewsManager()

    result = news_manager.search(keyword, 10)

    json = simplejson.dumps(result, separators=(',',':'))
    if callback != "": json = callback + "(" + json + ")"
    self.response.headers["Content-Type"] = "text/javascript"
    self.response.out.write(json)
