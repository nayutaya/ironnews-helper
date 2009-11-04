# -*- coding: utf-8 -*-

from BeautifulSoup import BeautifulSoup

from hatenabookmark import HatenaBookmark

class TitleFetcher:
  def __init__(self):
    username, password = HatenaBookmark.read_credential()
    self.hatena_bm = HatenaBookmark(username, password)

  def fetch_title(self, url):
    response = self.hatena_bm.post(url)
    xml      = response.read()

    doc   = BeautifulSoup(xml)
    title = doc.find("title")

    return title.string.strip()


import os
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.ext.webapp import template

class HomePage(webapp.RequestHandler):
  def get(self):
    fetcher = TitleFetcher()
    title = fetcher.fetch_title("http://www.asahi.com/national/update/1031/OSK200910310079.html")
    html = title
    self.response.out.write(html)

if __name__ == "__main__":
  application = webapp.WSGIApplication(
    [
      (r"/", HomePage),
    ],
    debug = True)
  run_wsgi_app(application)
