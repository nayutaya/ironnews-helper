# -*- coding: utf-8 -*-

from base64 import b64encode
from time import time
from random import random
from datetime import datetime
import sha
import httplib
from BeautifulSoup import BeautifulSoup

class WSSE:
  @classmethod
  def create_created(cls):
    return datetime.now().isoformat() + "Z"

  @classmethod
  def create_nonce(cls):
    return b64encode(sha.sha(str(time() + random())).digest())

  @classmethod
  def create_digest(cls, password, nonce, created):
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

#from xml.etree import ElementTree
class TitleFetcher:
  def __init__(self):
    username, password = HatenaBookmark.read_credential()
    self.hatena_bm = HatenaBookmark(username, password)

  def fetch_title(self, url):
    response = self.hatena_bm.post(url)
    xml      = response.read()
    doc = BeautifulSoup(xml)
    title = doc.find("title")
    return title.string.strip()

fetcher = TitleFetcher()


print "Content-Type: text/plain"
print ""

xml = u"""<?xml version="1.0" encoding="utf-8"?>
<entry xmlns="http://purl.org/atom/ns#">
  <title>asahi.com（朝日新聞社）：大阪環状線が再開　店舗火災で一時全線運転見合わせ - 社会</title>
  <link rel="related" type="text/html" href="http://www.asahi.com/national/update/1031/OSK200910310079.html" />
  <link rel="alternate" type="text/html" href="ironnews/20091104#17131575" />
  <link rel="service.edit" type="application/x.atom+xml" href="atom/edit/17131575" title="asahi.com（朝日新聞社）：大阪環状線が再開　店舗火災で一時全線運転見合わせ - 社会" />
  <author>
    <name>ironnews</name>
  </author>
  <generator url="" version="0.1">Hatena::Bookmark</generator>
  <issued>2009-11-04T11:47:54</issued>
  <id>tag:hatena.ne.jp,2005:bookmark-ironnews-17131575</id>
  <summary type="text/plain"></summary>
</entry>"""

print fetcher.fetch_title("http://www.asahi.com/national/update/1031/OSK200910310079.html")


#tree = ElementTree.fromstring(xml)
#for e in tree.getiterator():
#    print e.tag
#print "---"
#entry = tree.find("{http://purl.org/atom/ns#}*")
#print entry
#title = tree.find("{http://purl.org/atom/ns#}title")
#print unicode(title.text)

"""
doc = BeautifulSoup(unicode(xml))
title = doc.find("title")
#print doc.prettify()
print title.prettify()
print title

import sys
print sys.getdefaultencoding()

import json

#print type(title.string.decode("utf-8"))
#print "hoge" + title.string

x = unicode(title.string)
print json.write(x)
"""
