#!/usr/bin/env python
import mincemeat, sys, md5, hashlib, time, itertools


start_time=time.time()

#input is saved in the variable
input = sys.argv[1]

# To break the list into list of lists
def chunks(l, n):
    for i in xrange(0, len(l), n):
        yield l[i:i+n]


allowed=list("abcdefghijklmnopqrstuvwxyz0123456789");
datalist=[]

for   i in range(1,5):
 for j in list(itertools.product(allowed, repeat=i)):
   datalist.append(''.join(j))

#Breaking down the list into list of lists(of size 10000 each)
data=list(chunks(datalist, 10000))

#insering the input in each list inside data list
for i in data:
  i.insert(0,input)


datasource = dict(enumerate(data))

def mapfn(k, v):
    import md5, hashlib
    list=[]
    input=v[0]
    for i in v:
      if(hashlib.md5(i).hexdigest()[:5]==input):
       list.append(i)
    yield 'Found', list

def reducefn(k, vs):
  result=[]
  for i in vs:
    if len(i)!=0:
      for j in i:
        result.append(j)
  return result
 
s = mincemeat.Server()
s.datasource = datasource
s.mapfn = mapfn
s.reducefn = reducefn

results = s.run_server(password="changeme")

print results
print("--- time taken : %s seconds ---" % (time.time() - start_time))
