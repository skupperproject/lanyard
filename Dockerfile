FROM mirror.gcr.io/library/alpine:latest

# Set up build arguments (provided by buildx)
ARG TARGETOS
ARG TARGETARCH

# Install base tools and nginx, and conditionally add mongodb-tools + oha
RUN apk update && apk add --no-cache \
  bash \
  curl \
  wget \
  tar \
  traceroute \
  openssl \
  iperf3 \
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
  postgresql15-client \
  redis \
  nginx && \
  if [ "$TARGETOS" = "linux" ] && [ "$TARGETARCH" != "s390x" ] && [ "$TARGETARCH" != "ppc64le" ]; then \
    apk add --no-cache mongodb-tools && \
    wget -qO /usr/local/bin/oha https://github.com/hatoo/oha/releases/latest/download/oha-linux-${TARGETARCH} && \
    chmod +x /usr/local/bin/oha; \
  fi

# Set Go version and download URL
ENV GO_VERSION=1.22.8
ENV GO_URL=https://dl.google.com/go/go${GO_VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz

# Download and install Go
RUN wget -O go.tar.gz $GO_URL && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz

# Set Go path
ENV PATH="/usr/local/go/bin:${PATH}"

# Verify Go installation
RUN go version

# Expose default HTTP port
EXPOSE 8080

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;", "-c", "/etc/nginx/nginx.conf"]
