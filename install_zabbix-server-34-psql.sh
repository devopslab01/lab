#!/bin/bash

echo
echo "--- Install Zabbix Server 3.4 with Postgres ---"
echo
echo "ENV: Ubuntu 18.04 LTS (bionic)"
echo

mkdir -p /root/install
cd /root/install

if [ ! -f "zabbix-release_3.4-1+bionic_all.deb" ]; then wget https://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+bionic_all.deb; fi
dpkg -i zabbix-release_3.4-1+bionic_all.deb
apt update

apt install -y zabbix-server-pgsql
apt install -y zabbix-frontend-php
apt install -y postgresql postgresql-contrib

sudo -i PWD=/var/lib/postgresql/ -u postgres psql << EOF
DROP DATABASE IF EXISTS zabbix;
EOF

sudo -i PWD=/var/lib/postgresql/ -u postgres psql << EOF
CREATE USER zabbix;
ALTER USER zabbix WITH PASSWORD 'zabbixdbpass';
CREATE DATABASE zabbix OWNER zabbix;
GRANT ALL PRIVILEGES ON DATABASE zabbix TO zabbix;
EOF

zcat /usr/share/doc/zabbix-server-pgsql/create.sql.gz | sudo -u postgres psql zabbix

sed -i -e "/DBHost=/s/.*/DBHost=/" /etc/zabbix/zabbix_server.conf
sed -i -e "/DBPassword=/s/.*/DBPassword=zabbixdbpass/" /etc/zabbix/zabbix_server.conf
sed -i -e "/DBName=/s/.*/DBName=zabbix/" /etc/zabbix/zabbix_server.conf
sed -i -e "/DBUser=/s/.*/DBUser=zabbix/" /etc/zabbix/zabbix_server.conf
