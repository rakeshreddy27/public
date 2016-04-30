#!/usr/bin/env python

import sys
import string
import json

psum=0
pcount=0
osum=0
ocount=0

for line in sys.stdin:
  data = json.loads(line.strip())
  screenName=data['user']['screen_name']
  text=data['text']
  
  if screenName=='PrezOno':
    psum=psum+len(text)
    pcount=pcount+1
  else:
    osum=osum+len(text)
    ocount=ocount+1
  
  
print '%s\t%d' % ('osum', osum)
print '%s\t%d' % ('ocount',ocount)
print '%s\t%d' % ('psum', psum)
print '%s\t%d' % ('pcount', pcount)
    

  
