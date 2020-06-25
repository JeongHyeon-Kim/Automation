#!/bin/bash
file=$1
while read line; do
        echo ${line%-*}
done < $file

# using this script after removing src, rpm, el*, etc.

