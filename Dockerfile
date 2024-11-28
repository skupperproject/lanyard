FROM alpine:latest

# Install base tools without tshark
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
    bind-tools \
    iproute2 \
    openssh-client \
    python3 \
    procps \
    coreutils \
    mongodb-tools \
    postgresql-client \
    py3-flask

# Install Go separately in a minimal way
RUN apk add --no-cache --virtual .build-deps go && \
    mkdir -p /usr/local/go/bin && \
    mv /usr/bin/go /usr/local/go/bin/ && \
    apk del .build-deps

# Copy the Flask app
COPY app.py /app.py

# Expose port 5000 for the app.py
EXPOSE 5000

CMD ["python3", "/app.py"]
