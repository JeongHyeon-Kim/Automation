#!/bin/bash
file=$1
options="options"
usage="usage"
help_arr=("-h" "--help")
pass_num=0

while read line; do
  status_message=$(man $line 2>&1)
  if [[ ${status_message,,} =~ $options ]] || [[ ${status_message,,} =~ $usage ]]; then
    echo $line",PASS"
  else
    pass_count=0
    for h_arr in "${help_arr[@]}"; do
      status_message=$($line $h_arr 2>&1)
      if [[ ${status_message,,} =~ $options ]] || [[ ${status_message,,} =~ $usage ]]; then
        pass_count=$((pass_count+1))
      fi
    done
    if [ $pass_count -gt $pass_num ]; then
      echo $line",PASS"
    else
      echo $line",FAIL"
    fi
  fi
done < $file
