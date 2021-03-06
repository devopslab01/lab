#!/bin/bash

echo
echo "--- Install Zabbix Server 3.4 with Local Postgres DB ---"
echo
echo "ENV: Ubuntu 18.04 LTS (bionic)"
echo "PWD: `pwd`"
echo "USR: `whoami`"
echo

#--- ENV -------------------------------------------------------------

export DEBIAN_FRONTEND="noninteractive"

DIR="/opt/lab_workdir"
ZABBIX_URL="https://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+bionic_all.deb"
ZABBIX_DEB="zabbix-release_3.4-1+bionic_all.deb"

#---------------------------------------------------------------------

echo "Configuring `hostname -s` ..."

if [ ! -f "$ZABBIX_DEB" ]; then wget ${ZABBIX_URL}; sudo dpkg -i $ZABBIX_DEB; fi
apt update
apt policy zabbix-server-pgsql

systemctl stop zabbix-server


apt install -y zabbix-server-pgsql
apt install -y zabbix-frontend-php
apt install -y postgresql postgresql-contrib
apt install -y zabbix-agent
apt install -y php-pgsql

sudo -i PWD=/var/lib/postgresql/ -u postgres psql << EOF
DROP DATABASE IF EXISTS zabbix;
EOF

sudo -i PWD=/var/lib/postgresql/ -u postgres psql << EOF
CREATE USER zabbix;
ALTER USER zabbix WITH PASSWORD 'zabbixdbpass';
CREATE DATABASE zabbix OWNER zabbix;
GRANT ALL PRIVILEGES ON DATABASE zabbix TO zabbix;
EOF

zcat /usr/share/doc/zabbix-server-pgsql/create.sql.gz | sudo -u zabbix psql zabbix

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
systemctl --no-pager status apache2
systemctl restart zabbix-server
systemctl --no-pager status zabbix-server
systemctl restart postgresql
systemctl --no-pager status postgresql

echo
echo "Zabbix web logns: Admin/zabbix"

echo
echo "Done."
