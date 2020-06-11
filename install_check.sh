#!/bin/bash
file=$1
protected="protected"
success="Complete"
already="already installed"
nopackage="No Package"
nopackage2="No package"
obsolete="obsoleted"

while read line; do
        install_message=$(yum install -y $line 2>&1)
        if [[ $install_message =~ $success ]]; then
                echo "Install,$line,P,$(rpm -qa | wc -l)"
        elif [[ $install_message =~ $protected ]]; then
                echo "Install,$line,Protected Package,$(rpm -qa | wc -l)"
        elif [[ $install_message =~ $already ]]; then
                if [[ $install_message =~ $obselete ]]; then
                        echo "Install,$line,Obsoleted,$(rpm -qa | wc -l)"
                else
                        echo "Install,$line,Already Installed,$(rpm -qa | wc -l)"
                fi
        elif [[ $install_message =~ $nopackage ]] || [[ $install_message =~ $nopackage2 ]]; then
                echo "Install,$line,No Package,$(rpm -qa | wc -l)"
        else
                echo "Install,$line,Exception,$(rpm -qa | wc -l)"
        fi
done < $file
