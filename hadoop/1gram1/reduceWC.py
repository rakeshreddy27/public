#!/usr/bin/env python

import sys
import string

old_year = None

for line in sys.stdin:
  (year,word) = line.strip().split('\t',1)
  if old_year != year:
    if old_year:
      print '%s\t%d' % (old_year,wordsInYear)
    wordsInYear=0
    old_year = year
  try:
    wordsInYear=wordsInYear+int(word)
  except:
    continue
print '%s\t%d' % (old_year,wordsInYear)
