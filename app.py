# -*- coding: utf-8 -*-

import os
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.ext.webapp import template
from BeautifulSoup import BeautifulSoup
import json

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

class HatenaBookmarkGetTitleApi(webapp.RequestHandler):
  def get(self):
    fetcher = TitleFetcher()
    #self.response.out.write(html)

    result = {}
    urls = [self.request.get("url%02i" % (i + 1)) for i in range(10)]
    for url in urls:
      if url != "":
        title = fetcher.fetch_title(url)
        result[url] = title

    self.response.out.write(json.write(result))

if __name__ == "__main__":
  application = webapp.WSGIApplication(
    [
      (r"/hatena/bookmark/get_title", HatenaBookmarkGetTitleApi),
    ],
    debug = True)
  run_wsgi_app(application)
