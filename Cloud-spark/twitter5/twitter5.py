# Spark example to print the average tweet length using Spark
# PGT April 2016   
# To run, do: spark-submit --master yarn-client twitter5.py hdfs://hadoop2-0-0/data/twitter/part-03212

from __future__ import print_function
import sys, json
from pyspark import SparkContext
from pyspark.sql import SQLContext,Row

# Given a full tweet object, return the text of the tweet
def getInfo(line):
  try:
    js = json.loads(line)
    text = js['text'].encode('ascii', 'ignore')
    user = js['user']['screen_name']
    return [(user,text)]
  except Exception as a:
    return []
  
if __name__ == "__main__":
  if len(sys.argv) < 2:
    print("enter a filename")
    sys.exit(1)
 
   
  sc = SparkContext(appName="twitter5")
  sqlContext = SQLContext(sc)
  
  tweets = sc.textFile(sys.argv[1])
  
  texts = tweets.flatMap(getInfo)
  
  df = sqlContext.createDataFrame(texts.map(lambda (u,t): Row(text = t, length = len(t), user = u)))
  df.registerTempTable("tweets")
  
  tweetMost = sqlContext.sql("SELECT user, count(*) as count FROM tweets group by user order by count desc")
  top5 = sqlContext.sql("SELECT user, avg(length) as length FROM tweets group by user order by length desc")
  bottom5 = sqlContext.sql("SELECT user, avg(length) as length FROM tweets group by user order by length asc")
  
  results_tweetMost = tweetMost.first()
  result_top5 = top5.take(5)
  result_bottom5 = bottom5.take(5)
  
  print(results_tweetMost)
    
  for r in result_top5:
    print(r)
  
  for r in result_bottom5:
    print(r)
  
  sc.stop()