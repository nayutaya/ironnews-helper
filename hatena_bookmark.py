# -*- coding: utf-8 -*-

#import sys
#sys.path.append("lib")

import re
import urllib
import urllib2
import base64
import sha
import time
import random
import datetime
from BeautifulSoup import BeautifulSoup

class MyHTTPErrorProcessor(urllib2.HTTPErrorProcessor):
  def http_response(self, request, response):
    code, msg, hdrs = response.code, response.msg, response.info()
    if code not in (200, 201):
      response = self.parent.error("http", request, response, code, msg, hdrs)
    return response

class HatenaBookmark:
  @classmethod
  def create_entry_url(cls, url):
    return re.sub(re.compile(r"^http://"), "http://b.hatena.ne.jp/entry/", url)

  @classmethod
  def fetch_url(cls, url):
    request = urllib2.Request(url = url)
    request.add_header("User-Agent", "ironnews")
    io = urllib2.urlopen(request)
    try:
      return io.read()
    finally:
      io.close()

  @classmethod
  def trim_script_tag(cls, html):
    pattern = re.compile(r"<script.+?>.*?</script>", re.IGNORECASE | re.DOTALL)
    return re.sub(pattern, "", html)

  @classmethod
  def extract_summary(cls, html):
    doc = BeautifulSoup(html)
    summary = doc.find("blockquote", {"id": "entry-extract-content"})
    summary.find("cite").extract()
    contents = [elem.string.strip() for elem in summary.findAll(text = True)]
    return "".join(contents)

  @classmethod
  def extract_title(cls, html):
    document = BeautifulSoup(html)
    title    = document.find("a", {"id": "head-entry-link"})
    contents = [elem.string.strip() for elem in title.findAll(text = True)]
    return "".join(contents)

  @classmethod
  def get_summary(cls, url):
    entry_url = cls.create_entry_url(url)
    src1 = cls.fetch_url(entry_url)
    src2 = cls.trim_script_tag(src1)
    return cls.extract_summary(src2)

  @classmethod
  def create_wsse_created(cls):
    return datetime.datetime.now().isoformat() + "Z"

  @classmethod
  def create_wsse_nonce(cls):
    return base64.b64encode(sha.sha(str(time.time() + random.random())).digest())

  @classmethod
  def create_wsse_digest(cls, password, nonce, created):
    return base64.b64encode(sha.sha(nonce + created + password).digest())

  @classmethod
  def format_wsse_token(cls, username, digest, nonce, created):
    format = 'UsernameToken Username="%(u)s", PasswordDigest="%(p)s", Nonce="%(n)s", Created="%(c)s"'
    value  = dict(u = username, p = digest, n = nonce, c = created)
    return format % value

  @classmethod
  def create_wsse_token(cls, username, password):
    created = cls.create_wsse_created()
    nonce   = cls.create_wsse_nonce()
    digest  = cls.create_wsse_digest(password, nonce, created)
    return cls.format_wsse_token(username, digest, nonce, created)

  @classmethod
  def create_http_header(cls, username, password):
    return {
      "Content-Type": "text/xml",
      #"User-Agent"  : "ironnews",
      "User-Agent"  : "hoge",
      "X-WSSE"      : cls.create_wsse_token(username, password),
    }

  @classmethod
  def create_post_request_xml(cls, url):
    return (
      '<entry xmlns="http://purl.org/atom/ns#">'
      '<title>title</title>'
      '<link rel="related" type="text/html" href="') + url + ('" />'
      '</entry>')

  @classmethod
  def post(cls, url, username, password):
    atom_url = "http://b.hatena.ne.jp/atom/post"
    data = cls.create_post_request_xml(url)

    request = urllib2.Request(url = atom_url, data = data)
    request.add_header("Content-Type", "text/xml")
    request.add_header("User-Agent", "ironnews")
    request.add_header("X-WSSE", cls.create_wsse_token(username, password))

    opener = urllib2.build_opener(MyHTTPErrorProcessor)
    urllib2.install_opener(opener)

    io = urllib2.urlopen(request)
    try:
      return io.read()
    finally:
      io.close()

  @classmethod
  def get_title(cls, url, username, password):
    xml   = cls.post(url, username, password)
    doc   = BeautifulSoup(xml)
    title = doc.find("title").string.strip()
    return title

"""
url = "http://www.asahi.com/national/update/0314/NGY200903140002.html"
entry_url = HatenaBookmark.create_entry_url(url)
src1 = HatenaBookmark.fetch_url(entry_url)
src2 = HatenaBookmark.trim_script_tag(src1)

f = open("out.html", "w")
f.write(src2)
f.close()

print HatenaBookmark.extract_title(src2)
#return HatenaBookmark.extract_summary(src2)
"""