#!/usr/bin/env python

import sys
import string
import json

psum=0
pcount=0
osum=0
ocount=0
totalweek={}
prezweek={}

for line in sys.stdin:
  try:
    data = json.loads(line.strip())
    screenName=data['user']['screen_name']
    datetime=data['created_at'].lower().split()
    text=data['text']
    week=datetime[0]
    date=datetime[1]+datetime[2]+datetime[5]
    hour=datetime[3].split(':')[0]
    if week in totalweek:
      totalweek[week].add(date)
    else:
      totalweek[week]=set([date])
      
    if screenName=='PrezOno':
      psum=psum+len(text)
      pcount=pcount+1
      print '%s\t%d' % (week+'Tweets',1)
      print '%s\t%d' % (hour+'Tweets',1)
      if week in prezweek:
        totalweek[week+'po'].add(date)
      else:
        prezweek[week+'po']=set([date])
    else:
      osum=osum+len(text)
      ocount=ocount+1
  except:
      continue
      
 

for k,v in totalweek.iteritems():
  try:
    print '%s\t%s' % ('x'+k, v)
  except:
    continue

for k,v in prezweek.iteritems():
  try:
    print '%s\t%s' % ('x'+k, v)
  except:
    continue
    
print '%s\t%d' % ('osum', osum)
print '%s\t%d' % ('ocount',ocount)
print '%s\t%d' % ('psum', psum)
print '%s\t%d' % ('pcount', pcount)
    

  
