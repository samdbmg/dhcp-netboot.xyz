#!/bin/bash

DHCP_RANGE_START=${1:-192.168.0.1}

# Start the netboot container and run it in the background
docker run --net=host -e DHCP_RANGE_START=${DHCP_RANGE_START} samdbmg/dhcp-netboot.xyz &
DOCKER_PROCESS=$!

# Catch ctrl-c and clean up
function cleanup() {
    echo "Caught SIGINT, stopping VM"
    vagrant destroy -f

    echo "Waiting for Docker to stop"
    wait ${DOCKER_PROCESS}

    exit 0
}
trap cleanup INT

# Bring up the VM - this will fail because Vagrant can't SSH to it, but that's fine
vagrant up || true

# Wait for Ctrl-C
while true; do
    sleep 10
done
