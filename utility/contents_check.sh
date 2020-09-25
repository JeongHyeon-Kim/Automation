#!/bin/bash
file=$1
while read line; do
	grep -rn "Warning : Intel Processor" $line
done < $file

## This is script for searching words in directory group
## input file example ##

## example.txt
#/bin
#/boot
#/dev
#/etc
#/home
#/lib
#/lib64
#/media
#/mnt
#/opt
#/root
#/run
#/sbin
#/srv
#/tmp
#/usr
#/var
