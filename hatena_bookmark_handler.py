# -*- coding: utf-8 -*-

import simplejson
from google.appengine.ext import webapp

from hatena_bookmark_manager import HatenaBookmarkManager

class GetTitleApi(webapp.RequestHandler):
  def get(self):
    self.process()

  def post(self):
    self.process()

  def process(self):
    numbers  = range(1, 10 + 1)
    urls     = dict([(number, self.request.get("url%i" % number)) for number in numbers])
    callback = self.request.get("callback")

    bookmark_manager = HatenaBookmarkManager()

    result = {}
    for number in numbers:
      url = urls[number]
      if url == "": continue

      title = bookmark_manager.get_title(url)

      result[number] = {
        "url"  : url,
        "title": title,
      }

    json = simplejson.dumps(result, separators=(',',':'))
    if callback != "": json = callback + "(" + json + ")"
    self.response.headers["Content-Type"] = "text/javascript"
    self.response.out.write(json)

class GetSummaryApi(webapp.RequestHandler):
  def get(self):
    self.process()

  def post(self):
    self.process()

  def process(self):
    numbers  = range(1, 10 + 1)
    urls     = dict([(number, self.request.get("url%i" % number)) for number in numbers])
    callback = self.request.get("callback")

    bookmark_manager = HatenaBookmarkManager()

    result = {}
    for number in numbers:
      url = urls[number]
      if url == "": continue

      summary = bookmark_manager.get_summary(url)

      result[number] = {
        "url"    : url,
        "summary": summary[1],
      }

    json = simplejson.dumps(result, separators=(',',':'))
    if callback != "": json = callback + "(" + json + ")"
    self.response.headers["Content-Type"] = "text/javascript"
    self.response.out.write(json)
