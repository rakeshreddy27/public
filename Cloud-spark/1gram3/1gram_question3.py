#/data/1gram/googlebooks-eng-all-1gram-20120701-y

from __future__ import print_function
from pyspark import SparkConf, SparkContext
import sys, json

input = sys.argv[1]

conf = SparkConf().setAppName('1gram3')

sc = SparkContext(conf=conf)

input_data = sc.textFile(input).map(lambda line: line.split('\t'))

yearAllwordsLength = input_data.map( lambda arr: (int(arr[1]), float(len(arr[0])),1 ))

reduceyearlength = yearAllwordsLength.reduceByKey(lambda (a, b) : (a[0]+b[0],a[1]+b[1]))

YearwordAverage = reduceyearlenght.map(lambda res : (res[0], float(res[1][0]/res[1][1]) )


YearwordAverage.saveAsTexFile("AverageWordLengthsforAllYears")

sc.stop()

