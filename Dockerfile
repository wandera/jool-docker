FROM alpine:edge

LABEL maintainer="Zircon team <ww_zirconsquad@jamf.com>"

ARG JOOL_VER=4.1.14-r0

RUN apk --no-cache add \
    jool-tools=${JOOL_VER} \
    iptables \
    ip6tables

COPY *.sh /
RUN chmod +x /*.sh

ENTRYPOINT ["/setup.sh"]
