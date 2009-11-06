# -*- coding: utf-8 -*-

import sys
sys.path.append("lib")

from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app

import hatenabookmark_handler

if __name__ == "__main__":
  application = webapp.WSGIApplication(
    [
      (r"/hatena-bookmark/get-title",   hatenabookmark_handler.GetTitleApi),
      (r"/hatena-bookmark/get-summary", hatenabookmark_handler.GetSummaryApi),
    ],
    debug = True)
  run_wsgi_app(application)
