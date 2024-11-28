FROM alpine:latest

# Install base tools without tshark
RUN apk update && apk add --no-cache \
 bash \
 curl \
 wget \
 tar \
 traceroute \
 openssl \
 iperf \
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

# Install Go 1.22.8 manually to /usr/local/go
ENV GO_VERSION=1.22.8
RUN wget https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz && \
 tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz && \
 rm go$GO_VERSION.linux-amd64.tar.gz

# Set Go path
ENV PATH="/usr/local/go/bin:${PATH}"

# Verify Go installation
RUN go version

# Copy the Flask app
COPY app.py /app.py

# Expose port 5000 for the app.py
EXPOSE 5000

# Run the Flask app
CMD ["python3", "/app.py"]