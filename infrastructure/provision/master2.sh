#!/bin/bash
set -e

# Wait for join script to exist
while [ ! -f /vagrant/provision/join.sh ]; do
  echo "Waiting for join.sh from master1..."
  sleep 5
done

# Join as control plane
bash /vagrant/provision/join.sh --control-plane
