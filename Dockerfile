FROM alpine:3.20 AS builder

RUN apk add build-base cmake fakeroot libcap-setcap bsd-compat-headers

COPY msd_lite /opt/msd_lite
WORKDIR /opt/msd_lite

RUN mkdir build && \
    cd build && \
    cmake .. && \
    make && make install

RUN setcap cap_net_raw+ep /usr/local/bin/msd_lite

FROM alpine:3.20

COPY --from=builder /usr/local/bin/msd_lite /usr/bin/msd_lite
COPY --from=builder /usr/local/etc/msd_lite/msd_lite.conf.sample /etc/msd_lite/msd_lite.conf

ENTRYPOINT ["/usr/bin/msd_lite"]
CMD ["-c", "/etc/msd_lite/msd_lite.conf"]
