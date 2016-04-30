

from __future__ import print_function
import sys, json, string
from pyspark import SparkContext

  
if __name__ == "__main__":
  if len(sys.argv) < 2:
    print("enter a filename")
    sys.exit(1)
   
  sc = SparkContext(appName="1")
  
  file1 = sc.textFile(sys.argv[1],)
  map1=file1.map(lambda l:(l.strip().lower().split()[1],1))
  red1=map1.reduceByKey(lambda a,b:a+b)
  sort=red1.sortByKey()
 
  
  # Just show 10 tweet lengths to validate this works
  print(sort.take(10))
  # Print out the statsprint(red2.stats())
  
  # Save to your local HDFS folder
  sort.saveAsTextFile("1gram1")
  
  sc.stop()
