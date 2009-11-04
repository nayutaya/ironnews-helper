# -*- coding: utf-8 -*-

print "Content-Type: text/html"
print ""
print "hello"

f = open("config/hatena.id")
username = f.readline()
password = f.readline()
f.close()

print username
print password
