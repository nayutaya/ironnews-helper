# -*- coding: utf-8 -*-

import sha
import logging
from google.appengine.ext import webapp
from google.appengine.api import memcache

import simplejson
from BeautifulSoup import BeautifulSoup

from hatenabookmark import HatenaBookmark

class TitleFetcher:
  def __init__(self):
    username, password = HatenaBookmark.read_credential()
    self.hatena_bm = HatenaBookmark(username, password)

  def fetch_title(self, url):
    logging.info("get title: " + url)
    key = self.create_key(url)

    cache = memcache.get(key)
    if cache is not None:
      logging.info("cache hit")
      return cache
    else:
      logging.info("cache miss")
      response = self.hatena_bm.post(url)
      xml      = response.read()
      doc      = BeautifulSoup(xml)
      title    = doc.find("title").string.strip()
      memcache.add(key, title, 60 * 60)
      return title

  def create_key(self, url):
    return "hatena_bookmark_title_" + sha.sha(url).hexdigest()

class GetTitleApi(webapp.RequestHandler):
  def get(self):
    self.process()

  def post(self):
    self.process()

  def process(self):
    numbers  = range(1, 10 + 1)
    urls     = [self.request.get("url%i" % number) for number in numbers]
    callback = self.request.get("callback")

    fetcher = TitleFetcher()

    result = {}
    for number in numbers:
      url = urls[number - 1]
      if url != "":
        title = fetcher.fetch_title(url)
        result[number] = {
          "url"  : url,
          "title": title,
        }

    json = simplejson.dumps(result, separators=(',',':'))
    if callback != "": json = callback + "(" + json + ")"
    self.response.headers["Content-Type"] = "text/javascript"
    self.response.out.write(json)

import re
def trim_script_tag(html):
  pattern = re.compile(r"<script.+?>.*?</script>", re.IGNORECASE | re.DOTALL)
  return re.sub(pattern, "", html)

import urllib
import urllib2
def get_summary(url):
  entry_url = re.sub(re.compile(r"^http://"), "http://b.hatena.ne.jp/entry/", url)
  req = urllib2.Request(url = entry_url)
  req.add_header("User-Agent", "ironnews")
  io = urllib2.urlopen(req)
  src = io.read()
  io.close()

  src = trim_script_tag(src)
  doc = BeautifulSoup(src)

  summary = doc.find("blockquote", {"id": "entry-extract-content"})
  summary.find("cite").extract()

  return "".join([elem.string.strip() for elem in summary.findAll(text = True)])

class GetSummaryApi(webapp.RequestHandler):
  def get(self):
    self.process()

  def post(self):
    self.process()

  def process(self):
    numbers  = range(1, 10 + 1)
    urls     = [self.request.get("url%i" % number) for number in numbers]
    callback = self.request.get("callback")

    result = {}
    for number in numbers:
      url = urls[number - 1]
      if url == "": continue

      summary = get_summary(url)

      result[number] = {
        "url"    : url,
        "summary": summary,
      }

    json = simplejson.dumps(result, separators=(',',':'))
    if callback != "": json = callback + "(" + json + ")"
    self.response.headers["Content-Type"] = "text/javascript"
    self.response.out.write(json)
