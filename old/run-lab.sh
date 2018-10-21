#!/bin/bash

if [ -z "$1" ]
  then
    echo "No runner supplied"
    echo "USAGE: $0 <action> <target>"
    echo
    cat lab.conf
    exit 1
fi

if [ -z "$2" ]
  then
    echo "No target supplied"
    echo
    cat lab.conf
    exit 1
fi

echo
echo "--- Run Lab ---"
echo

echo "Running: $1"
echo "Target   $2"
echo

ssh super@$2 -n "sudo mkdir -p /opt/labfiles; sudo chown super:super /opt/labfiles"
scp $1 super@$2:/opt/labfiles/
ssh super@$2 -n "cd /opt/labfiles; sudo /opt/labfiles/$1"
