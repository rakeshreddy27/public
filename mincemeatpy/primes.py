#!/usr/bin/env python
import mincemeat
import time

start_time=time.time()
datalist=range(2,10000000);

def chunks(l, n):
    for i in xrange(0, len(l), n):
        yield l[i:i+n]

data=list(chunks(datalist, 10000))

datasource = dict(enumerate(data))
def mapfn(k, v):
    
    list=[]
    def isPrime(n):
        if n < 2 or n%2 == 0 and n!=2:
            return False
        if n == 2:
            return True
        else:
            for x in range(3, int(n**0.5)+1, 2):
                if n%x == 0:
                    return False
            return True
    def isPalindrome(x):
        num = str(x)[::-1]
        return str(x) == num
    
    for i in v:
        if isPrime(i) and isPalindrome(i):
            list.append(i) 
    yield 'number',list

def reducefn(k, vs):
    list=[]
    for i in vs:
        if len(i)!=0:
            for j in i:
                list.append(j)
    return list

s = mincemeat.Server()
s.datasource = datasource
s.mapfn = mapfn
s.reducefn = reducefn

results = s.run_server(password="changeme")
print results
print("--- time taken : %s seconds ---" % (time.time() - start_time))
