FROM alpine:3.11

LABEL maintainer="Martin Kulich <martin.kulich@wandera.com>"

ARG JOOL_VER=4.0.6-r3

RUN apk --no-cache add \
    jool-tools=${JOOL_VER} \
    iptables \
    ip6tables

COPY *.sh /
RUN chmod +x /*.sh

CMD ["/setup.sh"]
