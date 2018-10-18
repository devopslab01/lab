# Architecture

````
bastion [192.168.200.99]
  host-kvm01 [192.168.200.11]
  host-kvm02 [192.168.200.12]
  host-kvm03 [192.168.200.13]
  <...>
  node-u1801 [192.168.200.201]
  node-u1802 [192.168.200.202]
  node-u1803 [192.168.200.203]
  node-u1804 [192.168.200.204]
  node-u1805 [192.168.200.205]
  <...>
  node-c701 [192.168.200.221]
  node-c702 [192.168.200.222]
  node-c703 [192.168.200.223]
  node-c704 [192.168.200.224]
  node-c705 [192.168.200.225]
  <...>
  
````

# Get scripts

````
sudo su - root
git clone https://github.com/devopslab01/lab

git add -A; git commit -m "fix"; git push
````

# Configurations

Zabbix server (3.4) with Postgres backend       - https://github.com/devopslab01/lab/blob/master/install_zabbix-server-34-psql.sh
