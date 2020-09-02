#!/bin/bash
file=$1
options="OPTIONS"
usage="Usage"

#echo "help check"
while read line; do
        #echo $line
        status_message=$(man $line 2>&1)
        if [[ ${status_message,,} =~ ${options,,} ]] || [[ ${status_message,,} =~ ${usage,,} ]]; then
                echo $line":PASS"
        else
                echo $line":FAIL"
        fi
done < $file
