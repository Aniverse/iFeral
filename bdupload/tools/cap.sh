#!/bin/bash
time for c in {01..20}  # take 20 screenshots
do
i=`expr $i + 150`	# every 2.5 minutes (150sec)
timestamp=`date -u -d @$i +%H:%M:%S`
./ffmpeg -y -ss $timestamp -i "../../../torrents/Bound 1996 1080p GBR Blu-ray AVC DTS-HD MA 5.1-ESiR/BDMV/STREAM/00005.m2ts" -vframes 1 -s 1920x1080 test$c.png 2>/dev/null
echo Writing test$c.png $timestamp
done
