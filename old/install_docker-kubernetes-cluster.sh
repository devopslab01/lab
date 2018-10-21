#! /bin/bash

echo
echo "--- Install Docker Kubernetes Cluster ---"
echo
echo "ENV: Ubuntu 18.04 LTS (bionic)"
echo

node1="u18node01.lab.local"
node2="192.168.200.202"
node3="192.168.200.203"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
apt-get update
apt-get -y install kubeadm
