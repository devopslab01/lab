#!/bin/bash

echo
echo "--- Install Zabbix Server 3.4 with Local Postgres DB ---"
echo
echo "ENV: Ubuntu 18.04 LTS (bionic)"
echo

#--- ENV -------------------------------------------------------------

DIR="/opt/lab_workdir"
ZABBIX_URL="https://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+bionic_all.deb"
ZABBIX_DEB="zabbix-release_3.4-1+bionic_all.deb"

#---------------------------------------------------------------------

HOSTS=`grep "^zabbix_pgsql_local:" lab.conf |awk '{$1=""; print}'`
SER=`grep "^user:" lab.conf |awk '{print $2}'`

echo "User:   $USER"
echo "Hosts: $HOSTS"
echo

CD="cd $DIR"

for HOST in $HOSTS; do
    echo "Configuring $host ..."

    ssh $USER@$HOST -n "sudo mkdir -p $DIR"
    ssh $USER@$HOST -n "sudo chown $USER:$USER $DIR"

    ssh $USER@$HOST -n "$CD; if [ ! -f "$ZABBIX_DEB" ]; then wget ${ZABBIX_URL}; sudo dpkg -i $ZABBIX_DEB; fi"
    ssh $USER@$HOST -n "sudo apt-get update"
    ssh $USER@$HOST -n "sudo apt policy"

    ssh $USER@$HOST -n "sudo systemctl stop zabbix-server"

    ssh $USER@$HOST -n "sudo apt install -y zabbix-server-pgsql"
    ssh $USER@$HOST -n "sudo apt install -y zabbix-frontend-php"
    ssh $USER@$HOST -n "sudo apt install -y postgresql postgresql-contrib"
    ssh $USER@$HOST -n "sudo apt install -y zabbix-agent"
    ssh $USER@$HOST -n "sudo apt install -y php-pgsql"

    ssh $USER@$HOST -n "sudo -i PWD=/var/lib/postgresql/ -u postgres psql << EOF
DROP DATABASE IF EXISTS zabbix;
EOF"

    ssh $USER@$HOST -n "sudo -i PWD=/var/lib/postgresql/ -u postgres psql << EOF
CREATE USER zabbix;
ALTER USER zabbix WITH PASSWORD 'zabbbixpassdb';
CREATE DATABASE zabbix OWNER zabbix;
GRANT ALL PRIVILEGES ON DATABASE zabbix TO zabbix;
EOF"

    ssh $USER@$HOST -n "zcat /usr/share/doc/zabbix-server-pgsql/create.sql.gz | sudo -u zabbix psql zabbix"

done

echo
echo "Done."
