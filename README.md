# jool-docker

[![Docker Build Status](https://img.shields.io/docker/build/wanderadock/jool.svg)](https://hub.docker.com/r/wanderadock/jool/)
[![GitHub release](https://img.shields.io/github/release/WanderaOrg/jool-docker.svg)](https://github.com/WanderaOrg/jool-docker/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/WanderaOrg/jool-docker/blob/master/LICENSE)

[Jool](https://www.jool.mx/en/index.html) is a powerful kernel-space namespace-aware Stateful NAT64 and SIIT implementation.
This repo contains a simple docker-wrapped configurator for the tool.
Even though Jool supports both iptables and netfilter backend, this image uses iptables only.

## Features

* set up Jool 4.x in Stateful NAT64 mode in current network namespace:
  * host network
  * docker network
  * kubernetes pod

## Prerequisities

Before you're able to run the image, your host machine has to have Jool installed and loaded as module.
Follow [Jool docs](https://www.jool.mx/en/documentation.html) for installation instructions.

Example for Ubuntu 18.04:

```bash
apt-get update
wget https://github.com/NICMx/Jool/releases/download/v4.0.6/jool-dkms_4.0.6-1_all.deb -O /tmp/jool-dkms_4.0.6-1_all.deb
apt install -y /tmp/jool-dkms_4.0.6-1_all.deb
modprobe jool
modprobe ip6table_mangle
```

## Usage

The container has to run with extended capabilities for network.

To set up Jool on local network with default well-known prefix `64:ff9b::/96`:

```bash
docker run --cap-add=NET_ADMIN --network host wanderadock/jool /setup.sh
```

To set up Jool on docker network `test` with custom prefix `2001:db8:1234::/96`:

```bash
docker run --cap-add=NET_ADMIN --network test wanderadock/jool /setup.sh 2001:db8:1234::/96
```

If you ran Jool on top of your host network, you may need to cleanup:

```bash
docker run --cap-add=NET_ADMIN --network host wanderadock/jool /cleanup.sh
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
      command: ["/setup.sh"]
      securityContext:
        capabilities:
          add: ["NET_ADMIN"]
  ...
```

## Docker repository

The tool is released as docker image, check the [repository](https://hub.docker.com/r/wanderadock/jool/).
