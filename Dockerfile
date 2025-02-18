FROM mirror.gcr.io/library/alpine:latest

# Set up build arguments (provided by buildx)
ARG TARGETOS
ARG TARGETARCH

# Install base tools and nginx
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
  nginx && \
  # Conditionally install mongodb-tools if not s390x
  if [ "$TARGETOS" = "linux" ] && [ "$TARGETARCH" != "s390x" ]; then \
    apk add --no-cache mongodb-tools; \
  fi && \
  # Conditionally install oha if not s390x
  if [ "$TARGETOS" = "linux" ] && [ "$TARGETARCH" != "s390x" ]; then \
    wget -qO /usr/local/bin/oha https://github.com/hatoo/oha/releases/latest/download/oha-linux-${TARGETARCH} && \
    chmod +x /usr/local/bin/oha; \
  fi

# Set Go version
ENV GO_VERSION=1.22.8
# Compose the correct URL for the architecture
ENV GO_URL=https://dl.google.com/go/go${GO_VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz

# Download and install Go based on target architecture
RUN wget -O go.tar.gz $GO_URL && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz

# Set Go path
ENV PATH="/usr/local/go/bin:${PATH}"

# Verify Go installation
RUN go version

# Expose default HTTP port
EXPOSE 8080

# Command to run nginx
CMD ["nginx", "-g", "daemon off;", "-c", "/etc/nginx/nginx.conf"]
