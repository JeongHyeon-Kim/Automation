#!/bin/bash
file=$1

while read line; do
        dnf module enable -y $line
done < $file
