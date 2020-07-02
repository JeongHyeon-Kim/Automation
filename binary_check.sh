#!/bin/bash
file=$1
bin_path="/usr/bin/"
sbin_path="/usr/sbin/"
options="OPTIONS"

while read line; do

        if [[ $line =~ $bin_path ]]; then
		#echo "bin"
	        status_message=$(man ${line#${bin_path}} 2>&1)
		#echo $status_message 
        	if [[ $status_message =~ $options ]]; then
			echo $line": help exist"
		else
			echo $line": help non-exsit"
		fi	
        elif [[ $line =~ $sbin_path ]]; then
		#echo "sbin"
	        status_message=$(man ${line#${sbin_path}} 2>&1)
		#echo $status_message
        	if [[ $status_message =~ $options ]]; then
			echo $line": help exist"
		else
			echo $line": help non-exsit"
		fi	
	else
		echo $line"has in exception case"
	fi 
done < $file


