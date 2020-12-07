#!/bin/bash
file=$1

while read line; do
  rpm -ql $line | grep bin/
done < $file
