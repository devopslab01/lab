#!/bin/bash

echo
echo "--- Install Zabbix Server 3.4 with Postgres ---"
echo
echo "ENV: Ubuntu 18.04 LTS (bionic)"
echo

mkdir -p /root/install
cd /root/install

ZABBIX_DEB="zabbix-release_3.4-1+bionic_all.deb"
if [ ! -f "$ZABBIX_DEB" ]; then wget https://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/${ZABBIX_DEB}; fi
dpkg -i $ZABBIX_DEB
apt update

systemctl stop zabbix-server

apt install -y zabbix-server-pgsql
apt install -y zabbix-frontend-php
apt install -y postgresql postgresql-contrib
apt install -y zabbix-agent

sudo -i PWD=/var/lib/postgresql/ -u postgres psql << EOF
DROP DATABASE IF EXISTS zabbix;
EOF

sudo -i PWD=/var/lib/postgresql/ -u postgres psql << EOF
CREATE USER zabbix;
ALTER USER zabbix WITH PASSWORD 'zabbixdbpass';
CREATE DATABASE zabbix OWNER zabbix;
GRANT ALL PRIVILEGES ON DATABASE zabbix TO zabbix;
EOF

cd /tmp
zcat /usr/share/doc/zabbix-server-pgsql/create.sql.gz | sudo -u zabbix psql zabbix
cd /root/install

if [ ! -f "/etc/zabbix/zabbix_server.conf_original" ]; then cp /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf_original; fi

sed -i -e "/DBHost=/s/.*//" /etc/zabbix/zabbix_server.conf
sed -i -e "/DBPassword=/s/.*//" /etc/zabbix/zabbix_server.conf
sed -i -e "/DBName=/s/.*//" /etc/zabbix/zabbix_server.conf
sed -i -e "/DBUser=/s/.*//" /etc/zabbix/zabbix_server.conf
sed -i -e 's/#.*$//' -e '/^$/d' /etc/zabbix/zabbix_server.conf

echo "DBHost=" >> /etc/zabbix/zabbix_server.conf
echo "DBPassword=zabbixdbpass" >> /etc/zabbix/zabbix_server.conf
echo "DBName=zabbix" >> /etc/zabbix/zabbix_server.conf
echo "DBUser=zabbix" >> /etc/zabbix/zabbix_server.conf

sed -i -e "/php_value date.timezone/s/.*/        php_value date.timezone Europe\/Vilnius/" /etc/apache2/conf-enabled/zabbix.conf

systemctl restart apache2
systemctl --no-pager status apache
systemctl restart zabbix-server
systemctl --no-pager status zabbix-server
systemctl restart postgresql
systemctl --no-pager status postgresql
