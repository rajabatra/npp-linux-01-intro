#!/usr/bin/bash

# INCLUDE ALL COMMANDS NEEDED TO PERFORM THE LAB
# This file will get called from capture_submission.sh

# Enable IP forwarding (optional, but not harmful here)
docker exec clab-lab1-part1-switch sysctl -w net.ipv4.ip_forward=1

# Set interfaces up
docker exec clab-lab1-part1-switch ip link set dev eth1 up
docker exec clab-lab1-part1-switch ip link set dev eth2 up
docker exec clab-lab1-part1-switch ip link set dev eth3 up
docker exec clab-lab1-part1-switch ip link set dev eth4 up

# Create a Linux bridge inside the switch container
docker exec clab-lab1-part1-switch ip link add name br0 type bridge

# Set the bridge up
docker exec clab-lab1-part1-switch ip link set dev br0 up

# Add interfaces to the bridge
docker exec clab-lab1-part1-switch ip link set dev eth1 master br0
docker exec clab-lab1-part1-switch ip link set dev eth2 master br0
docker exec clab-lab1-part1-switch ip link set dev eth3 master br0
docker exec clab-lab1-part1-switch ip link set dev eth4 master br0
