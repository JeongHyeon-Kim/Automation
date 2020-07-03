#!/bin/bash
file=$1
#bin_path="/usr/bin/"
#sbin_path="/usr/sbin/"
#sbin_path2="/sbin/"
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

:<<END
        echo ${line#*bin/}
        status_message=$(man ${line#*bin/} 2>&1)
        if [[ $status_message =~ $options ]]; then
                echo $line":PASS"
        else
                echo $line":FAIL"
        fi

        if [[ $line =~ $bin_path ]]; then
                #echo "bin"
                #echo ${line#${bin_path}}
                status_message=$(man ${line#${bin_path}} 2>&1)
                #echo $status_message
                if [[ $status_message =~ $options ]]; then
                        echo $line":PASS"
                else
                        echo $line":FAIL"
                fi
        elif [[ $line =~ $sbin_path ]]; then
                #echo "sbin"
                #echo ${line#${sbin_path}}
                status_message=$(man ${line#${sbin_path}} 2>&1)
                #echo $status_message
                if [[ $status_message =~ $options ]]; then
                        echo $line":PASS"
                else
                        echo $line":FAIL"
                fi
        else
                echo $line":EXCEPTION"
        fi
END
done < $file
