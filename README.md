# jool-docker

[![Docker Build Status](https://img.shields.io/docker/cloud/build/wanderadock/jool)](https://hub.docker.com/r/wanderadock/jool/)
[![GitHub release](https://img.shields.io/github/v/release/wandera/jool-docker)](https://github.com/wandera/jool-docker/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/wandera/jool-docker/blob/master/LICENSE)

[Jool](https://nicmx.github.io/Jool/en/index.html) is a powerful kernel-space namespace-aware Stateful NAT64 and SIIT implementation.
This repo contains a simple docker-wrapped configurator for the tool.
Even though Jool supports both iptables and netfilter backend, this image uses iptables only.

## Features

* set up Jool 4.x in Stateful NAT64 mode in current network namespace:
  * host network
  * docker network
  * kubernetes pod

## Prerequisities

Before you're able to run the image, your host machine has to have Jool installed and loaded as module.
Follow [Jool docs](https://nicmx.github.io/Jool/en/documentation.html) for installation instructions.

Example for Ubuntu 18.04:

```bash
apt-get update
wget https://github.com/NICMx/Jool/releases/download/v4.0.8/jool-dkms_4.0.8-1_all.deb -O /tmp/jool-dkms_4.0.8-1_all.deb
apt install -y /tmp/jool-dkms_4.0.8-1_all.deb
modprobe jool
modprobe ip6table_mangle
```

## Usage

The container has to run with extended capabilities for network.

To set up Jool on local network with default well-known prefix `64:ff9b::/96`:

```bash
docker run --cap-add=NET_ADMIN --network host wanderadock/jool
```

To set up Jool on docker network `test` with custom prefix `2001:db8:1234::/96`:

```bash
docker run --cap-add=NET_ADMIN --network test wanderadock/jool --pool6=2001:db8:1234::/96
```

To set up Jool on docker network `test` with custom IPv6 MTU `1420`:

```bash
docker run --cap-add=NET_ADMIN --network test wanderadock/jool --lowest-ipv6-mtu=1420
```

If you ran Jool on top of your host network, you may need to cleanup:

```bash
docker run --cap-add=NET_ADMIN --network host --entrypoint /cleanup.sh wanderadock/jool
```

Otherwise all Jool instances get cleaned when network namespace is destroyed (usually when the {container/docker network/kubernetes pod} is destroyed).

## Usage with kubernetes

Jool can be used to set up NAT64 within kubernetes pod. It still requires jool kernel module on the host machine.

```yaml
apiVersion: apps/v1
kind: Pod
metadata:
  name: jool-example
spec:
  initContainers:
    - name: jool
      image: wanderadock/jool:latest
      args:
        - "--pool6=2001:db8:1234::/96" # use custom prefix
        - "--lowest-ipv6-mtu=1420" # use custom IPv6 MTU
      securityContext:
        capabilities:
          add: ["NET_ADMIN"]
  ...
```

## Docker repository

The tool is released as docker image, check the [repository](https://hub.docker.com/r/wanderadock/jool/).
