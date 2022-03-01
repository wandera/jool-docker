#!/bin/sh

POOL6="64:ff9b::/96"
LOWEST_IPV6_MTU=1280
HANDLE_RST_DURING_FIN_RCV="false"
DROP_EXTERNALLY_INITIATED_TCP="false"

while [ $# -gt 0 ]; do
  case "$1" in
    --pool6=*)
      POOL6="${1#*=}"
      ;;
    --lowest-ipv6-mtu=*)
      LOWEST_IPV6_MTU="${1#*=}"
      ;;
    --handle-rst-during-fin-rcv)
      HANDLE_RST_DURING_FIN_RCV="true"
      ;;
    --drop-externally-initiated-tcp)
      DROP_EXTERNALLY_INITIATED_TCP="true"
      ;;
    *)
      printf "************************************************************\n"
      printf "* Error: Invalid argument '${1}'.\n"
      printf "* Usage: setup.sh [options...]\n"
      printf "*        --pool6=<IPv6>\n"
      printf "*        --lowest-ipv6-mtu=<mtu>\n"
      printf "*        --handle-rst-during-fin-rcv\n"
      printf "*        --drop-externally-initiated-tcp\n"
      printf "************************************************************\n"
      exit 1
  esac
  shift
done

jool instance add --iptables --pool6 ${POOL6} default
jool global update lowest-ipv6-mtu ${LOWEST_IPV6_MTU}
jool global update handle-rst-during-fin-rcv ${HANDLE_RST_DURING_FIN_RCV}
jool global update drop-externally-initiated-tcp ${DROP_EXTERNALLY_INITIATED_TCP}

iptables -t mangle -A PREROUTING -j JOOL
ip6tables -t mangle -A PREROUTING -j JOOL
