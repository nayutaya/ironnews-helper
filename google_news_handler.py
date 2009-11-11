# -*- coding: utf-8 -*-

import logging
import simplejson
from google.appengine.ext import webapp
from google.appengine.api import urlfetch

from google_news_manager import GoogleNewsManager

class SearchApi(webapp.RequestHandler):
  def get(self):
    callback = self.request.get("callback")

    keyword = u"私鉄"
    num     = 10

    news_manager = GoogleNewsManager()

    # MEMO: 1度だけ再試行する
    try:
      articles = news_manager.search(keyword, num)
    except urlfetch.DownloadError:
      logging.info("retry download")
      articles = news_manager.search(keyword, num)

    result = articles

    json = simplejson.dumps(result, separators=(',',':'))
    if callback != "": json = callback + "(" + json + ")"
    self.response.headers["Content-Type"] = "text/javascript"
    self.response.out.write(json)
