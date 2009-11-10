# -*- coding: utf-8 -*-

import re
import urllib
import urllib2
import httplib
from BeautifulSoup import BeautifulSoup

from wsse import WSSE

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




  def __init__(self, username, password):
    self.username = username
    self.password = password

  def create_http_header(self):
    return {
      "Content-Type": "text/xml",
      #"User-Agent"  : "ironnews",
      "User-Agent"  : "hoge",
      "X-WSSE"      : WSSE.create_token(self.username, self.password),
    }

  def create_post_request_xml(self, url):
    return (
      '<entry xmlns="http://purl.org/atom/ns#">'
      '<title>title</title>'
      '<link rel="related" type="text/html" href="') + url + ('" />'
      '</entry>')

  def post(self, url):
    header  = self.create_http_header()
    request = self.create_post_request_xml(url)
    connection = httplib.HTTPConnection("b.hatena.ne.jp")
    connection.request("POST", "/atom/post", request, header)
    return connection.getresponse()
