#!/usr/bin/env python

import sys
import string

old_key = None

for line in sys.stdin:
  (key,value) = line.strip().split('\t',1)
  if old_key != key:
    if old_key:
      if old_key[0]!='x':
        print '%s\t%d' % (old_key,total)
      else:
        print '%s\t%d' % (old_key,len(s))
    total=0
    s=set()
    old_key = key
  try:
    if old_key[0]!='x':
      total=total+int(value)
    else:
      s=s.union(eval(value))
  except:
    continue
if old_key[0]!='x':
  print '%s\t%d' % (old_key,total)
else:
  print '%s\t%d' % (old_key,len(s))
