# -*- coding: utf-8 -*-

from base64 import b64encode
from time import time
from random import random
from datetime import datetime
import sha
import httplib

class WSSE:
  @classmethod
  def create_created(cls):
    return datetime.now().isoformat() + "Z"

  @classmethod
  def create_nonce(cls):
    return b64encode(sha.sha(str(time() + random())).digest())

  @classmethod
  def create_digest(cls, passowrd, nonce, created):
    return b64encode(sha.sha(nonce + created + password).digest())

  @classmethod
  def format_token(cls, username, digest, nonce, created):
    format = 'UsernameToken Username="%(u)s", PasswordDigest="%(p)s", Nonce="%(n)s", Created="%(c)s"'
    value  = dict(u = username, p = digest, n = nonce, c = created)
    return format % value

  @classmethod
  def create_token(cls, username, password):
    created = cls.create_created()
    nonce   = cls.create_nonce()
    digest  = cls.create_digest(password, nonce, created)
    return cls.format_token(username, digest, nonce, created)

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
      "User-Agent"  : "ironnews",
      "X-WSSE"      : WSSE.create_token(self.username, self.password),
    }

  def create_post_request_xml(self, url):
    return (
      '<entry xmlns="http://purl.org/atom/ns#">'
      '<title>title</title>'
      '<link rel="related" type="text/html" href="') + url + ('" />'
      '</entry>')

  def post(self, url):
    header  = hb.create_http_header()
    request = hb.create_post_request_xml(url)
    connection = httplib.HTTPConnection("b.hatena.ne.jp")
    connection.request("POST", "/atom/post", request, header)
    return connection.getresponse()

print "Content-Type: text/plain"
print ""

username, password = HatenaBookmark.read_credential()
hb = HatenaBookmark(username, password)

response = hb.post("http://www.asahi.com/national/update/1031/OSK200910310079.html")

print response.read()
