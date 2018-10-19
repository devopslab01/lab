#!/bin/bash

if [ -z "$1" ]; then
  echo "USAGE: $0 <kvm_host> <kvm_guest> [<kvm_guest>] ..."
  exit 1
fi

echo
echo "--- Revert Snapshot in KVM ---"
echo

KVM_HOST=`uname -s`
KVM_GUESTS=`echo $* |tr -s ' '`

echo "KVM HOST:   $KVM_HOST"
echo "KVM GUESTS: $KVM_GUESTS"
echo

for GUEST in $KVM_GUESTS; do
  echo "--> Reverting snapshot on host $GUEST ..."

  SNAP=`sudo virsh snapshot-list $GUEST |tail -n2 |head -n1 |awk '{print $1}'`
  if [ -n "$SNAP" ]; then
    echo "Snapshot: $SNAP"
    sudo virsh snapshot-revert $GUEST $SNAP
    echo "Start $GUEST ..."
    sudo virsh start $GUEST

    echo "Snapshot reverted."
    echo
  else
    echo "ERROR: Guest $GUEST not found!"
  fi
done

echo "Done."
echo
