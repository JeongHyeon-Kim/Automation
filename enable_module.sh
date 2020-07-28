#!/bin/bash
file=$1

while read line; do
        dnf module enable -y $line
        repoquery | wc -l
done < $file
