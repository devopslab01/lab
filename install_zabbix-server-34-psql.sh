#!/bin/bash

echo
echo "--- Install Zabbix Server 3.4 with Postgres ---"
echo
echo "ENV: Ubuntu 18.04 LTS (bionic)"
echo

DIR="/opt/lab_workdir"
CD="cd $DIR"

HOSTS=`grep "^zabbix" lab.conf |awk '{$1=""; print}'`
USER=`grep "^user:" lab.conf |awk '{print $2}'`
echo "User:   $USER"
echo "Hosts: $HOSTS"
echo

for HOST in $HOSTS; do
    echo "Configuring $host ..."

    ssh $USER@$HOST -n "sudo mkdir -p $DIR"
    ssh $USER@$HOST -n "sudo chown super:super $DIR"

    ZABBIX_DEB="zabbix-release_3.4-1+bionic_all.deb"
    ZABBIX_URL="https://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+bionic_all.deb"
    ssh $USER@$HOST -n "$CD; if [ ! -f "$ZABBIX_DEB" ]; then wget ${ZABBIX_URL}; dpkg -i $ZABBIX_DEB; fi"
    ssh $USER@$HOST -n "sudo apt-get update"


    ssh $USER@$HOST -n "sudo systemctl stop zabbix-server"

    ssh $USER@$HOST -n "sudo apt-get install -y zabbix-server-pgsql"
    ssh $USER@$HOST -n "sudo apt-get install -y zabbix-frontend-php"
    ssh $USER@$HOST -n "sudo apt-get install -y postgresql postgresql-contrib"
    ssh $USER@$HOST -n "sudo apt-get install -y zabbix-agent"
    ssh $USER@$HOST -n "sudo apt-get install -y php-pgsql"
done

echo
echo "Done."
