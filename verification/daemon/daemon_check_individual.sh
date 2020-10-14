#!/bin/bash
file=$1
inactive="Active: inactive"
active="Active: active"
pass_num=3

while read line; do
	success_count=0
	fail_count=0
	exception_count=0
	sleep 1
        status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
        if [[ $status_message =~ $inactive ]]; then
                #echo "inactive"
		sleep 1
		systemctl start ${line#/usr/lib/systemd/system/}
		sleep 1
        	status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
        	if [[ $status_message =~ $inactive ]]; then
			#echo $line",inactive start failed"
			fail_count=$((fail_count+1))
        	elif [[ $status_message =~ $active ]]; then
			#echo $line",inactive start success"
			success_count=$((success_count+1))
			sleep 1
			systemctl stop ${line#/usr/lib/systemd/system/}
			sleep 1
	        	status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
			if [[ $status_message =~ $inactive ]]; then
				#echo "$line,active stop success"
				success_count=$((success_count+1))
				sleep 1
				systemctl start ${line#/usr/lib/systemd/system/}
				sleep 1
		        	status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
        			if [[ $status_message =~ $inactive ]]; then
					#echo $line",inactive start failed"
					fail_count=$((fail_count+1))
        			elif [[ $status_message =~ $active ]]; then
					#echo $line",inactive start success"
					success_count=$((success_count+1))
				else
					#echo $line",Exception"
					exception_count=$((exception_count+1))
				fi
	        	elif [[ $status_message =~ $active ]]; then
				#echo $line",active stop failed"
				fail_count=$((fail_count+1))
			else
				#echo $line",Exception"
				exception_count=$((exception_count+1))
			fi
		else
			#echo $line",Exception"
			exception_count=$((exception_count+1))
		fi
        elif [[ $status_message =~ $active ]]; then
		#echo "active"
		sleep 1
		systemctl stop ${line#/usr/lib/systemd/system/}
		sleep 1
        	status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
        	if [[ $status_message =~ $inactive ]]; then
			#echo "$line,active stop success"
			success_count=$((success_count+1))
			sleep 1
			systemctl start ${line#/usr/lib/systemd/system/}
			sleep 1
			status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
        		if [[ $status_message =~ $inactive ]]; then
                		#echo $line",inactive start failed"
				fail_count=$((fail_count+1))
        		elif [[ $status_message =~ $active ]]; then
                		#echo $line",inactive start success"
				success_count=$((success_count+1))
				sleep 1
				systemctl stop ${line#/usr/lib/systemd/system/}
				sleep 1
				status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
				if [[ $status_message =~ $active ]]; then
					#echo $line",active stop failed"
					fail_count=$((fail_count+1))
				elif [[ $status_message =~ $inactive ]]; then
					#echo $line",active stop success"
					success_count=$((success_count+1))
				else
					#echo $line",Exception"
					exception_count=$((exception_count+1))
				fi
        		else
                		#echo $line",Exception"
				exception_count=$((exception_count+1))
        		fi
        	elif [[ $status_message =~ $active ]]; then
			#echo $line",active stop failed"
			fail_count=$((fail_count+1))
		else
			#echo $line",Exception"
			exception_count=$((exception_count+1))
		fi
	else
		#echo $line",Exception"
		exception_count=$((exception_count+1))
	fi
	if [ $success_count -eq $pass_num ]; then
		echo $line",PASS"
	else
		echo $line",FAIL"
	fi
done < $file
