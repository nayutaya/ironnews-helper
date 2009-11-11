# -*- coding: utf-8 -*-

import sys
sys.path.append("lib")

from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app

import hatena_bookmark_handler
import yahoo_keyphrase_handler
import google_news_handler

if __name__ == "__main__":
  application = webapp.WSGIApplication(
    [
      (r"/hatena-bookmark/get-title",   hatena_bookmark_handler.GetTitleApi),
      (r"/hatena-bookmark/get-summary", hatena_bookmark_handler.GetSummaryApi),
      (r"/yahoo-keyphrase/extract",     yahoo_keyphrase_handler.ExtractApi),
      (r"/google-news/search",          google_news_handler.SearchApi),
    ],
    debug = True)
  run_wsgi_app(application)
