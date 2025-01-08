FROM alpine:edge

LABEL maintainer="Zircon team <ww_zirconsquad@jamf.com>"

ARG JOOL_VER=4.1.13-r0

RUN apk --no-cache add \
    jool-tools=${JOOL_VER}

COPY *.sh /
RUN chmod +x /*.sh

ENTRYPOINT ["/setup.sh"]
