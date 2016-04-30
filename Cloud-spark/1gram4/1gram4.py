from __future__ import print_function
import sys, json, re
from pyspark import SparkContext

def syllable(line):
  year=line.strip().lower().split()[1]
  word=line.strip().lower().split()[0]
  count = 0
  vowels = 'aeiouy'
  word = word.lower().strip(".:;?!")
  if word[0] in vowels:
      count +=1
  for index in range(1,len(word)):
      if word[index] in vowels and word[index-1] not in vowels:
          count +=1
  if word.endswith('e'):
      count -= 1
  if count == 0:
      count +=1
  return (year,count)
  
if __name__ == "__main__":
  if len(sys.argv) < 2:
    print("enter a filename")
    sys.exit(1)
  sc = SparkContext(appName="1gram4")
  file1 = sc.textFile(sys.argv[1],)
  map1 = file1.map(syllable)
  red1= map1.reduceByKey(lambda a,b:a+b)
  sort=red1.sortByKey()
  print(sort.take(10))
  sort.saveAsTextFile("1gram4")
  sc.stop()
