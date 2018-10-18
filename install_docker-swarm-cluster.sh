#! /bin/bash

echo
echo "--- Install Docker Swarm Cluster ---"
echo
echo "ENV: Ubuntu 18.04 LTS (bionic)"
echo

node1="u18node01.lab.local"
node2="192.168.200.202"
node3="192.168.200.203"

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt-get update

apt-get -y install docker-ce

systemctl --no-pager status docker

## -- node2
ssh super@$node2 "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"
ssh super@$node2 "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable'"
ssh super@$node2 "sudo apt-get update"

ssh super@$node2 "sudo apt-get -y install docker-ce"

ssh super@$node2 "sudo systemctl --no-pager status docker"

docker swarm init

cmd_join=`docker swarm join-token manager |grep "docker swarm join"`
ssh super@$node2 "sudo $cmd_join"

docker node ls

## -- node3

ssh super@$node3 "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"
ssh super@$node3 "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable'"
ssh super@$node3 "sudo apt-get update"

ssh super@$node3 "sudo apt-get -y install docker-ce"

ssh super@$node3 "sudo systemctl --no-pager status docker"

docker swarm init

cmd_join=`docker swarm join-token manager |grep "docker swarm join"`
ssh super@$node3 "sudo $cmd_join"

docker node ls
