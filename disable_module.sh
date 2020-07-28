#!/bin/bash
file=$1

echo "===================================="
while read line; do
        echo $line
        dnf module disable -y $line
        repoquery | wc -l
        echo "===================================="
done < $file
