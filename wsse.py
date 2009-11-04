# -*- coding: utf-8 -*-

from datetime import datetime
from time import time
from base64 import b64encode
from random import random
import sha

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
