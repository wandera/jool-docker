FROM alpine:3.13 as builder

RUN apk add --update curl tar build-base pkgconf-dev libnl3-dev iptables-dev argp-standalone autoconf libtool

RUN wget https://www.jool.mx/download/jool-4.1.5.tar.gz && \
    tar -xzf jool-4.1.5.tar.gz && cd jool-4.1.5/ && ./configure --build=x86_64 && \
    make && make install && cd - && rm -rf jool-4.1.5/ && rm -rf jool-4.1.5.tar.gz

# Runtime image
FROM alpine:3.13
RUN apk add libnl3-dev curl iptables ip6tables
COPY --from=builder /usr/local/bin/jool /usr/local/bin/jool
COPY --from=builder /usr/local/bin/joold /usr/local/bin/joold
COPY --from=builder /usr/lib/xtables/libxt_JOOL.so /usr/lib/xtables/libxt_JOOL.so

COPY *.sh /
RUN chmod +x /*.sh

ENTRYPOINT ["/setup.sh"]
