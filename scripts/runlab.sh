#!/bin/bash

echo
echo "--- Runlab ---"
echo

cat lab.conf | grep -v "#" | grep "runlab:" | while read line; do
  echo $line
  echo
  ACTION=`echo $line |awk '{print $2}'`
  TARGET=`echo $line |awk '{print $3}'`
  ARGUME=`echo $line |awk '{$1=$2=$3=""; print}'`

  ssh super@$TARGET -n "sudo mkdir -p /opt/runlab"
  ssh super@$TARGET -n "sudo chown super:super /opt/runlab"
  scp $ACTION super@$TARGET:/opt/runlab/
  ssh super@$TARGET -n "cd /opt/runlab; sudo ./$ACTION $ARGUME"
done
