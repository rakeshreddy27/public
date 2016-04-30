#!/usr/bin/env python

import sys
import string

def averageLen(lst):
    lengths = [len(i) for i in lst]
    if len(lengths)==0:
      return 0
    else:
      return (float(sum(lengths)) / len(lengths))
	  
old_year = None

for line in sys.stdin:
  (year,word) = line.strip().split('\t',1)
  if old_year != year:
    if old_year:
      print '%s\t%d' % (old_year,len(wordsInYear))
      print '%s\t%f' % ('avg'+old_year,averageLen(wordsInYear))
      wordsInYear.clear()
      old_year = year
    else:
      old_year = year
      wordsInYear=set()
  try:
    wordsInYear.add(word)
  except:
    continue
print '%s\t%d' % (old_year,len(wordsInYear))
print '%s\t%f' % ('avg'+old_year,averageLen(wordsInYear))
