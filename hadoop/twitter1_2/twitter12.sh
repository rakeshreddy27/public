#!/bin/bash
hadoop jar /root/hadoop-2.7.1/share/hadoop/tools/lib/hadoop-streaming-2.7.1.jar -D mapred.reduce.tasks=1 -input /data/twitter -output $1 -file *.py -mapper maptw12.py -reducer reducetw12.py
