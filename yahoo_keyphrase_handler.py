# -*- coding: utf-8 -*-

from google.appengine.ext import webapp
import simplejson

import yahoo

def read_application_id():
  f = open("config/yahoo.id")
  app_id = f.readline().strip()
  f.close()
  return app_id


class ExtractApi(webapp.RequestHandler):
  def get(self):
    app_id = read_application_id()
    text = u"２６日午後７時４０分ごろ、京都府長岡京市長岡の阪急京都線の踏切近くで、線路上にいた同市に住む男性（２９）が、河原町発梅田行き準急電車にはねられ、全身を強く打って即死した。運転士が警笛を鳴らしても退避しなかったといい、向日町署は自殺の可能性があるとみて調べている。　阪急によると、この電車は現場に８分間停車。後続など上下計２９本が３〜７分遅れとなり、約１万２５００人に影響した。"

    result = yahoo.Keyphrase.extract(app_id, text)

    callback = ""

    json = simplejson.dumps(result, separators=(',',':'))
    if callback != "": json = callback + "(" + json + ")"
    self.response.headers["Content-Type"] = "text/javascript"
    self.response.out.write(json)
