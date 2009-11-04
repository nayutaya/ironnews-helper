# -*- coding: utf-8 -*-

import httplib

from wsse import WSSE

class HatenaBookmark:
  def __init__(self, username, password):
    self.username = username
    self.password = password

  @classmethod
  def read_credential(cls):
    f = open("config/hatena.id")
    username = f.readline().strip()
    password = f.readline().strip()
    f.close()
    return (username, password)

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
