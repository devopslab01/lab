#! /bin/bash

echo
echo "--- Install Docker Swarm Cluster ---"
echo
echo "ENV: Ubuntu 18.04 LTS (bionic)"
echo

node1="u18node01.lab.local"
node2="192.168.200.202"
node3="u18node03.lab.local"

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt update

apt-get -y install docker-ce

systemctl --no-pager status docker

ssh super@$node2 "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"
ssh super@$node2 "add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable'"

