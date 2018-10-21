#! /bin/bash

echo
echo "--- Check Lab ---"
echo

grep "^node" lab.conf

HOSTS=`cat lab.conf |grep "^node" |awk '{print $2}'`
for host in $HOSTS; do
    echo $host
    # TODO: include check in configurations scripts

    # ssh -q user@downhost exit
    # $ echo $?
    # 255

    #$ ssh -q user@uphost exit
    #$ echo $?
    # 0
    ssh -n $host "uname -a"
done

echo
echo "-- end."
