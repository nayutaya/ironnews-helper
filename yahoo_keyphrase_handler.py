# -*- coding: utf-8 -*-

from google.appengine.ext import webapp

class ExtractApi(webapp.RequestHandler):
  def get(self):
    self.response.out.write("ok")
