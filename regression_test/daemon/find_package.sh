#!/bin/sh
file=$1

while read line; do
        install_message=$(yum provides $line | sed -n 2p)
        echo $line";"${install_message%% : *}
done < $file

# Displayed the package that the daemon belongs, When a daemon list (ex. /usr/lib/systemd/system/dhcrelay.service) is entered as an argument.
