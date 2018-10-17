#!/bin/bash

echo
echo "--- Install Zabbix Server 3.4 with Postgres ---"
echo
echo "ENV: Ubuntu 18.04 LTS (bionic)"
echo

mkdir -p /root/install
cd /root/install

wget https://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+bionic_all.deb
dpkg -i zabbix-release_3.4-1+bionic_all.deb
apt update

apt install -y zabbix-server-pgsql
apt install -y zabbix-frontend-php
apt install -y postgresql postgresql-contrib

sudo -i PWD=/var/lib/postgresql/ -u postgres psql << EOF
CREATE USER zabbix;
ALTER USER zabbix WITH PASSWORD 'zabbixdbpass';
CREATE DATABASE zabbix OWNER zabbix;
GRANT ALL PRIVILEGES ON DATABASE zabbix TO zabbix;
EOF
