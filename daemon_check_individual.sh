#!/bin/bash
file=$1
inactive="Active: inactive"
active="Active: active"

:<<END
function my_function(){
	systemctl start ${line#/usr/lib/systemd/system/}
	status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
	if [[ $status_message =~ $inactive ]]; then
		echo $line",inactive start failed"
	elif [[ $status_message =~ $active ]]; then
		echo $line",inactive start success"
	else
		echo $line",Exception"
	fi
}

function my_function2(){
	systemctl stop ${line#/usr/lib/systemd/system/}
	status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
	if [[ $status_message =~ $inactive ]]; then
		echo $line",inactive start failed"
	elif [[ $status_message =~ $active ]]; then
		echo $line",inactive start success"
	else
		echo $line",Exception"
	fi
}
END

while read line; do
	sleep 1
        status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
        if [[ $status_message =~ $inactive ]]; then
                #echo "inactive"
		sleep 1
		systemctl start ${line#/usr/lib/systemd/system/}
        	status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
        	if [[ $status_message =~ $inactive ]]; then
			echo $line",inactive start failed"
        	elif [[ $status_message =~ $active ]]; then
			echo $line",inactive start success"
			sleep 1
			systemctl stop ${line#/usr/lib/systemd/system/}
	        	status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
			if [[ $status_message =~ $inactive ]]; then
				echo "$line,active stop success"
				sleep 1
				systemctl start ${line#/usr/lib/systemd/system/}
		        	status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
        			if [[ $status_message =~ $inactive ]]; then
					echo $line",inactive start failed"
        			elif [[ $status_message =~ $active ]]; then
					echo $line",inactive start success"
				else
					echo $line",Exception"
				fi
	        	elif [[ $status_message =~ $active ]]; then
				echo $line",active stop failed"
			else
				echo $line",Exception"
			fi
		else
			echo $line",Exception"
		fi
        elif [[ $status_message =~ $active ]]; then
		#echo "active"
		sleep 1
		systemctl stop ${line#/usr/lib/systemd/system/}
        	status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
        	if [[ $status_message =~ $inactive ]]; then
			echo "$line,active stop success"
			sleep 1
			systemctl start ${line#/usr/lib/systemd/system/}
			status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
        		if [[ $status_message =~ $inactive ]]; then
                		echo $line",inactive start failed"
        		elif [[ $status_message =~ $active ]]; then
                		echo $line",inactive start success"
				sleep 1
				systemctl stop ${line#/usr/lib/systemd/system/}
				status_message=$(systemctl status ${line#/usr/lib/systemd/system/} 2>&1)
				if [[ $status_message =~ $inactive ]]; then
					echo $line",inactive start failed"
				elif [[ $status_message =~ $active ]]; then
					echo $line",inactive start success"
				else
					echo $line",Exception"
				fi
        		else
                		echo $line",Exception"
        		fi
        	elif [[ $status_message =~ $active ]]; then
			echo $line",active stop failed"
		else
			echo $line",Exception"
		fi
	else
		echo $line",Exception"
	fi
done < $file
