#!/bin/bash
file=$1

while read line; do
        echo $(dnf module enable -y $line)
done < $file