#!/bin/bash

FILENAMES="fileNames_DIGI-RAW_HYDJET_MB_run3.txt"

cat $FILENAMES | while read line 
do
    # do something with $line here
    echo "$line"
done
