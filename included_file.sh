#!/bin/bash
file=$1

while read line; do
        echo $(rpm -ql $line)"; "
done < $file
