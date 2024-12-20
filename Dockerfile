FROM mirror.gcr.io/library/alpine:latest

# Install base tools
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
  py3-flask

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

# Set Go path
ENV PATH="/usr/local/go/bin:${PATH}"

# Verify Go installation
RUN go version

# Copy the Flask app
COPY app.py /app.py

# Expose port 5000
EXPOSE 5000

# Run the Flask app
CMD ["python3", "/app.py"]

