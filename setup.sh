#!/bin/sh

POOL6="64:ff9b::/96"
LOWEST_IPV6_MTU=1280

while [ $# -gt 0 ]; do
  case "$1" in
    --pool6=*)
      POOL6="${1#*=}"
      ;;
    --lowest-ipv6-mtu=*)
      LOWEST_IPV6_MTU="${1#*=}"
      ;;
    *)
      printf "************************************************************\n"
      printf "* Error: Invalid argument '${1}'.\n"
      printf "* Usage: setup.sh [--pool6=<IPv6>] [--lowest-ipv6-mtu=<mtu>]\n"
      printf "************************************************************\n"
      exit 1
  esac
  shift
done

jool instance add --iptables --pool6 ${POOL6} default
jool global update lowest-ipv6-mtu ${LOWEST_IPV6_MTU}

iptables -t mangle -A PREROUTING -j JOOL
ip6tables -t mangle -A PREROUTING -j JOOL
