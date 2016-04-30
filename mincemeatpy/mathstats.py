#!/usr/bin/env python
import mincemeat
import time
import sys

start_time=time.time()
file = open(str(sys.argv[1]),'r')
data = list(file)
file.close()

# The data source can be any dictionary-like object
datasource = dict(enumerate(data))
#print datasource

def mapfn(k, v):
    for w in v.split():
        yield 'results',float(w)

def reducefn(k, vs):
    
    import math
    count=len(vs)
    summ=sum(vs)
    mean = summ/count
    temp=0
    for n in vs:
        temp=temp+(mean-n)*(mean-n)
    return [count,summ,math.sqrt(temp/count)]

s = mincemeat.Server()
s.datasource = datasource
s.mapfn = mapfn
s.reducefn = reducefn

results = s.run_server(password="changeme")
print("count : %s" % results['results'][0])
print("Sum : %s" % results['results'][1])
print("Std.dev : %s" % results['results'][2])
print("--- time taken : %s seconds ---" % (time.time() - start_time))
