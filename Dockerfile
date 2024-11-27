FROM alpine:latest

RUN apk update && apk add --no-cache \
    curl \
    traceroute \
    openssl \
    iperf \
    wget \
    busybox-extras \
    nmap \
    netcat-openbsd \
    tcpdump \
    mtr \
    socat \
    tshark \
    bind-tools \
    iproute2 \
    openssh-client

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

