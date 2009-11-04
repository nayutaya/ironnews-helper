# -*- coding: utf-8 -*-

from base64 import b64encode
from time import time
from random import random
from datetime import datetime
import sha
import httplib

def create_created():
  return datetime.now().isoformat() + "Z"

def create_nonce():
  return b64encode(sha.sha(str(time() + random())).digest())

def create_digest(passowrd, nonce, created):
  return b64encode(sha.sha(nonce + created + password).digest())

def format_token(username, digest, nonce, created):
  format = 'UsernameToken Username="%(u)s", PasswordDigest="%(p)s", Nonce="%(n)s", Created="%(c)s"'
  value  = dict(u = username, p = digest, n = nonce, c = created)
  return format % value

def create_wsse_auth(username, password):
  created = create_created()
  nonce   = create_nonce()
  digest  = create_digest(password, nonce, created)
  return format_token(username, digest, nonce, created)

def read_credential():
  f = open("config/hatena.id")
  username = f.readline().strip()
  password = f.readline().strip()
  f.close()
  return (username, password)

def create_request_xml(url):
  return (
    '<entry xmlns="http://purl.org/atom/ns#">'
    '<title>title</title>'
    '<link rel="related" type="text/html" href="') + url + ('" />'
    '</entry>')


print "Content-Type: text/plain"
print ""

username, password = read_credential()
useragent = "ironnews"

wsse = create_wsse_auth(username, password)

url = "http://www.asahi.com/national/update/1102/SEB200911020008.html"
request = create_request_xml(url)

# Set header for HTTPConnection
headers = {
  "Content-Type": "text/xml",
  "User-Agent"  : useragent,
  "X-WSSE"      : wsse,
}

connection = httplib.HTTPConnection("b.hatena.ne.jp")
connection.request("POST", "/atom/post", request, headers)

response = connection.getresponse()

print response.read()
