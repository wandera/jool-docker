#!/bin/sh

POOL6=${1:-"64:ff9b::/96"}

finish() {
  jool instance flush
}
trap finish SIGTERM SIGINT SIGQUIT

jool instance flush
jool instance add --iptables --pool6 ${POOL6}

while true; do sleep 1000; done