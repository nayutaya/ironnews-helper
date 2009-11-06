# -*- coding: utf-8 -*-

from google.appengine.ext import webapp
import simplejson

import yahoo

def read_application_id():
  f = open("config/yahoo.id")
  app_id = f.readline().strip()
  f.close()
  return app_id

class CachedKeyphrase:
  pass

class ExtractApi(webapp.RequestHandler):
  def get(self):
    numbers  = range(1, 10 + 1)
    texts    = [self.request.get("text%i" % number) for number in numbers]
    callback = self.request.get("callback")

    app_id = read_application_id()

    result = yahoo.Keyphrase.extract(app_id, texts[0])

    json = simplejson.dumps(result, separators=(',',':'))
    if callback != "": json = callback + "(" + json + ")"
    self.response.headers["Content-Type"] = "text/javascript"
    self.response.out.write(json)
