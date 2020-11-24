#!/bin/bash
file=$1
# Comparison string indicating status
inactive="Active: inactive"
active="Active: active"
failed="Active: failed"
# Performs two tests and returns to the state before the test
pass_num=2

systemctl daemon-reload
while read line; do
	success_count=0
	fail_count=0
	exception_count=0
	status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
	# Checking whether a phrase is included in a status message using regular expressions
	if [[ $status_message =~ $inactive ]] || [[ $status_message =~ $failed ]]; then
		#echo "inactive -> active"
		systemctl start ${line#/usr/lib/systemd/system/}
		status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
		if [[ $status_message =~ $inactive ]] || [[ $status_message =~ $failed ]]; then
			#echo $line",start failed"
			fail_count=$((fail_count+1))
		elif [[ $status_message =~ $active ]]; then
			#echo $line",start success"
			success_count=$((success_count+1))
			systemctl stop ${line#/usr/lib/systemd/system/}
			status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
			if [[ $status_message =~ $inactive ]] || [[ $status_message =~ $failed ]]; then
				#echo "$line,stop success"
				success_count=$((success_count+1))
			elif [[ $status_message =~ $active ]]; then
				#echo $line",stop failed"
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
		#echo "active -> inactive"
		systemctl stop ${line#/usr/lib/systemd/system/}
		status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
		if [[ $status_message =~ $inactive ]] || [[ $status_message =~ $failed ]]; then
			#echo "$line,stop success"
			success_count=$((success_count+1))
			systemctl start ${line#/usr/lib/systemd/system/}
			status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
			if [[ $status_message =~ $inactive ]] || [[ $status_message =~ $failed ]]; then
				#echo $line",start failed"
				fail_count=$((fail_count+1))
			elif [[ $status_message =~ $active ]]; then
				#echo $line",start success"
				success_count=$((success_count+1))
			else
				#echo $line",Exception"
				exception_count=$((exception_count+1))
			fi
		elif [[ $status_message =~ $active ]]; then
			#echo $line",stop failed"
			fail_count=$((fail_count+1))
		else
			#echo $line",Exception"
			exception_count=$((exception_count+1))
		fi
	else
		#echo $line",Exception"
		exception_count=$((exception_count+1))
	fi
	# If passes through 2 tests, PASS, otherwise FAIL
	if [ $success_count -eq $pass_num ]; then
		echo $line",PASS"
	else
		echo $line",FAIL"
	fi
done < $file
