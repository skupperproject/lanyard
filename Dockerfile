FROM mirror.gcr.io/library/alpine:latest

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
  mongodb-tools \
  postgresql15-client \
  nginx

# Set up build arguments (provided by buildx)
ARG TARGETOS
ARG TARGETARCH

# Set Go version
ENV GO_VERSION=1.22.8
# Compose the correct URL for the architecture
ENV GO_URL=https://dl.google.com/go/go${GO_VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz

# Download and install Go based on target architecture
RUN wget -O go.tar.gz $GO_URL && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz

# Add SSL certificates
COPY certs /etc/nginx/certs

# Set Go path
ENV PATH="/usr/local/go/bin:${PATH}"

# Verify Go installation
RUN go version

# Expose default HTTP port
EXPOSE 8080

# Command to run nginx
CMD ["nginx", "-g", "daemon off;", "-c", "/etc/nginx/nginx.conf"]

