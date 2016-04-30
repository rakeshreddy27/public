#!/usr/bin/env python

import sys
import string

old_key = None

for line in sys.stdin:
  (key,value) = line.strip().split('\t',1)
  if old_key != key:
    if old_key:
      print '%s\t%f' % (old_key,total)
    total=0
    old_key = key
  try:
    total=total+float(value)
  except:
    continue
print '%s\t%f' % (old_key,total)
