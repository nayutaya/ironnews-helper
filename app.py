# -*- coding: utf-8 -*-

import sys
sys.path.append("lib")

from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app

import hatena_bookmark_handler

if __name__ == "__main__":
  application = webapp.WSGIApplication(
    [
      (r"/hatena-bookmark/get-title",   hatena_bookmark_handler.GetTitleApi),
      (r"/hatena-bookmark/get-summary", hatena_bookmark_handler.GetSummaryApi),
    ],
    debug = True)
  run_wsgi_app(application)
