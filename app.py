# -*- coding: utf-8 -*-

import sys
sys.path.append("lib")

import os
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.ext.webapp import template
from google.appengine.api import memcache

import hatena_bookmark_handler
import yahoo_keyphrase_handler
import google_news_handler

class HomePage(webapp.RequestHandler):
  def get(self):
    stats  = memcache.get_stats()
    values = {
      "hits"  : stats["hits"],
      "misses": stats["misses"],
      "items" : stats["items"],
      "bytes" : stats["bytes"],
      "ratio" : str(int(stats["hits"]) * 100 / (int(stats["hits"]) + int(stats["misses"]))),
    }
    path = os.path.join(os.path.dirname(__file__), "home.html")
    html = template.render(path, values)
    self.response.out.write(html)

if __name__ == "__main__":
  application = webapp.WSGIApplication(
    [
      (r"/",                            HomePage),
      (r"/hatena-bookmark/get-title",   hatena_bookmark_handler.GetTitleApi),
      (r"/hatena-bookmark/get-summary", hatena_bookmark_handler.GetSummaryApi),
      (r"/yahoo-keyphrase/extract",     yahoo_keyphrase_handler.ExtractApi),
      (r"/google-news/search",          google_news_handler.SearchApi),
    ],
    debug = True)
  run_wsgi_app(application)
