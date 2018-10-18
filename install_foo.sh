#!/bin/bash

echo
echo "--- Install Zabbix Server 3.4 with Postgres ---"
echo
echo "ENV: Ubuntu 18.04 LTS (bionic)"
echo

HOSTS=`grep "^zabbix" lab.conf |awk '{$1=""; print}'`
USER=`grep "^user:" lab.conf |awk '{print $2}'`
echo "User:   $USER"
echo "Hosts: $HOSTS"
echo

for host in $HOSTS; do
    echo "Configuring $host ..."

done

echo
echo "Done."
