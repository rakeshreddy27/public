#!/usr/bin/env python

import sys
import string
import json

left=0
right=0
yes=0
no=0

for line in sys.stdin:
  try:
    data = json.loads(line.strip())
    geo=data['geo']
    if geo==None:
      no=no+1
    else:
      yes=yes+1
      left=left+float(geo['coordinates'][0])
      right=right+float(geo['coordinates'][1])
  except:
      continue
      
print '%s\t%d' % ('yes', yes)
print '%s\t%d' % ('no',no)
print '%s\t%f' % ('left', left)
print '%s\t%f' % ('right', right)
    