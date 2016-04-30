#!/usr/bin/env python
import sys
import string
import json



file = open('twittermail.txt','r')
data = list(file)
file.close()

x=json.loads(data[10]);

print x['created_at']
print len(x['text'])
y=x['user']['screen_name']
print y

z=x['created_at'].strip().lower().split()

print z[0]
c=z[1]+z[2]+z[5]
print c

p=z[3].split(':')[0]
print p

print x['geo']==None
print x['geo']['coordinates'][1]
#['coordinates'][0]
