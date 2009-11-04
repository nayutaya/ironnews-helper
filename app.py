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


print "Content-Type: text/plain"
print ""

username, password = read_credential()
useragent = "ironnews"

url = "http://www.asahi.com/national/update/1102/SEB200911020008.html"


wsse = create_wsse_auth(username, password)

request  = '<entry xmlns="http://purl.org/atom/ns#">'
request += '<title>title</title>'
request += '<link rel="related" type="text/html" href="' + url + '" />'
request += '</entry>'

# Set header for HTTPConnection
headers = {
  "Content-Type": "text/xml",
  "User-Agent"  : useragent,
  "X-WSSE"      : wsse,
}

con = httplib.HTTPConnection("b.hatena.ne.jp")
con.request("POST", "/atom/post", request, headers)

res = con.getresponse()
#print res

response = dict(status=res.status, reason=res.reason, data=res.read())
print response["data"]
