#!/bin/bash
file=$1
options="options"
usage="usage"

while read line; do
  status_message=$(man $line 2>&1)
  if [[ ${status_message,,} =~ $options ]] || [[ ${status_message,,} =~ $usage ]]; then
    echo $line",PASS"
  else
    echo $line",FAIL"
  fi
done < $file
