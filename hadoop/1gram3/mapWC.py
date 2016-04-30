#!/usr/bin/env python

import sys
import string

for line in sys.stdin:
  words = line.strip().lower().translate(None,string.punctuation).split()
  key=words[1]
  value=words[0]
  print '%s\t%s' % (key, value)
