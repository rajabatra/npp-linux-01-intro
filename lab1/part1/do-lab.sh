#!/usr/bin/bash

# INCLUDE ALL COMMANDS NEEDED TO PERFORM THE LAB
# This file will get called from capture_submission.sh


set -e

# Names of the hosts
hosts=(host1 host2 host3 host4)

# Name of the bridge
bridge_name=labbridge

# 1. Create bridge if not exists
if ! ip link show $bridge_name &>/dev/null; then
  echo "Creating bridge: $bridge_name"
  sudo ip link add name $bridge_name type bridge
  sudo ip link set dev $bridge_name up
fi

# 2. Loop over each host to connect them to the bridge
for host in "${hosts[@]}"; do
  # Set names for veth pairs
  veth_host="veth-${host}"
  veth_br="veth-${host}-br"

  # Delete if they already exist
  sudo ip link del $veth_host 2>/dev/null || true

  # Create veth pair
  sudo ip link add $veth_host type veth peer name $veth_br

  # Attach one end to bridge
  sudo ip link set $veth_br master $bridge_name
  sudo ip link set $veth_br up

  # Move one end into host namespace and bring up
  pid=$(docker inspect -f '{{.State.Pid}}' clab-lab1-part1-${host})
  sudo ip link set $veth_host netns $pid
  sudo nsenter -t $pid -n ip link set $veth_host name ethX
  sudo nsenter -t $pid -n ip link set ethX up
done
