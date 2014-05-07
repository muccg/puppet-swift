#!/bin/bash

cd /etc/swift/
#swift-ring-builder object.builder create 15 3 1
#swift-ring-builder account.builder create 15 3 1
#swift-ring-builder container.builder create 15 3 1
zone=1
for node in $@; do
IP=`host $node.rep.bpa.ccg | awk '{ print $4}'`
for letter in {b..l}; do swift-ring-builder object.builder add z$zone-$IP:6000/sd$letter 1; done;
for letter in {b..l}; do swift-ring-builder container.builder add z$zone-$IP:6001/sd$letter 1; done;
for letter in {b..l}; do swift-ring-builder account.builder add z$zone-$IP:6002/sd$letter 1; done;
zone=$(($zone+1))
done
swift-ring-builder object.builder rebalance
swift-ring-builder container.builder rebalance
swift-ring-builder account.builder rebalance
