#!/bin/sh

POOL6=${1:-"64:ff9b::/96"}

jool instance remove default

iptables -t mangle -D PREROUTING -j JOOL
ip6tables -t mangle -D PREROUTING -j JOOL
