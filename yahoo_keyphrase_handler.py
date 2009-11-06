# -*- coding: utf-8 -*-

import urllib
import urllib2
from google.appengine.ext import webapp

import json
from BeautifulSoup import BeautifulSoup


def read_application_id():
  f = open("config/yahoo.id")
  app_id = f.readline().strip()
  f.close()
  return app_id

def create_base_url():
  return "http://jlp.yahooapis.jp/KeyphraseService/V1/extract"

def create_url_params(app_id, text):
  return {
    "appid"   : app_id,
    "sentence": text.encode("utf-8"),
    "output"  : "xml",
  }

def create_url(app_id, text):
  base   = create_base_url()
  params = urllib.urlencode(create_url_params(app_id, text))
  return base + "?" + params

class ExtractApi(webapp.RequestHandler):
  def get(self):
    app_id = read_application_id()
    text = u"２６日午後７時４０分ごろ、京都府長岡京市長岡の阪急京都線の踏切近くで、線路上にいた同市に住む男性（２９）が、河原町発梅田行き準急電車にはねられ、全身を強く打って即死した。運転士が警笛を鳴らしても退避しなかったといい、向日町署は自殺の可能性があるとみて調べている。　阪急によると、この電車は現場に８分間停車。後続など上下計２９本が３〜７分遅れとなり、約１万２５００人に影響した。"
    url = create_url(app_id, text)

    req = urllib2.Request(url = url)
    io = urllib2.urlopen(req)
    try:
      xml = io.read()
    finally:
      io.close()

    doc      = BeautifulSoup(xml)
    results = doc.findAll("result")
    result = []
    for item in results:
      keyphrase = item.find("keyphrase").string.strip()
      score     = item.find("score").string.strip()
      result.append((keyphrase, score))

    callback = ""
    output = json.write(result)
    if callback != "":
      output = callback + "(" + output + ")"
    self.response.headers["Content-Type"] = "text/javascript"
    self.response.out.write(output)
