#! /bin/bash

echo
echo "--- Check Lab ---"
echo

grep "^node" lab.conf

HOSTS=`cat lab.conf |grep "^node" |awk '{print $2}'`
for host in $HOSTS; do
    echo $host
    # TODO: update linux
    # TODO: include check to configurations scripts
    ssh -n $host "uname -a"
done

echo
echo "-- end."
