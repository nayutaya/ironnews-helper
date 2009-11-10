# -*- coding: utf-8 -*-

import re
import urllib
import urllib2
import httplib
import base64
import sha
import time
import random
import datetime
from BeautifulSoup import BeautifulSoup

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
    header  = cls.create_http_header(username, password)
    request = cls.create_post_request_xml(url)
    connection = httplib.HTTPConnection("b.hatena.ne.jp")
    connection.request("POST", "/atom/post", request, header)
    return connection.getresponse()
