# Lanyard

A lightweight Docker image with essential networking and diagnostic tools.

## Table of Contents

- [Description](#description)
- [Included Tools](#included-tools)
- [How to Build the Image](#how-to-build-the-image)
- [Usage](#usage)
  - [Run an Interactive Shell](#run-an-interactive-shell)
  - [Execute Direct Commands](#execute-direct-commands)
  - [Usage Examples](#usage-examples)
- [Contribution](#contribution)
- [License](#license)

## Description

**Lanyard** is a Docker image based on Alpine Linux that contains a collection of networking and diagnostic tools. The goal is to provide a portable and consistent environment for testing, debugging, and monitoring networks.

## Included Tools

The image includes the following tools:

- **curl**: Command-line tool for transferring data with URLs.
- **traceroute**: Utility to trace the route that packets take to a network host.
- **openssl**: Library and tools for cryptography and SSL/TLS.
- **iperf**: Tool for measuring network bandwidth.
- **wget**: Tool for downloading files from the web.
- **telnet**: Telnet client for network connections.
- **nmap**: Network security scanner.
- **netcat (nc)**: Reads and writes data across network connections using TCP or UDP.
- **tcpdump**: Tool for capturing and analyzing network packets.
- **mtr**: Combines the functionality of `ping` and `traceroute`.
- **socat**: Bidirectional data transfer utility.
- **tshark**: Command-line version of Wireshark for packet analysis.
- **bind-tools**: Includes `dig` and `nslookup` for DNS queries.
- **iproute2**: Collection of utilities for network traffic control and configuration.
- **openssh-client**: SSH client for secure remote connections.

> **Note:** The `telnet` command is provided by the `busybox-extras` package.

## How to Build the Image

Clone this repository and navigate to the `lanyard` directory:

```bash
git clone https://github.com/your_username/lanyard.git
cd lanyard
```

Build the Docker image:

```bash
docker build -t lanyard .
```

Or, if you're using Podman:

```bash
podman build -t lanyard .
```

## Usage

### Run an Interactive Shell

To start a container and access an interactive shell:

```bash
docker run -it lanyard
```

### Execute Direct Commands

You can execute any tool directly when starting the container:

```bash
docker run lanyard [command] [arguments]
```

For example, to use `ping`:

```bash
docker run lanyard ping -c 4 google.com
```

### Usage Examples

- **Test Connection with `curl`:**

  ```bash
  docker run lanyard curl -I https://www.example.com
  ```

- **Port Scanning with `nmap`:**

  ```bash
  docker run lanyard nmap -v -A scanme.nmap.org
  ```

- **Measure Bandwidth with `iperf`:**

  - **Server:**

    ```bash
    docker run -p 5201:5201 lanyard iperf -s
    ```

  - **Client:**

    ```bash
    docker run lanyard iperf -c [SERVER_IP]
    ```

- **Packet Capture with `tcpdump`:**

  ```bash
  docker run --net=host --cap-add=NET_ADMIN --cap-add=NET_RAW lanyard tcpdump -i eth0
  ```

  > **Note:** The flags `--net=host`, `--cap-add=NET_ADMIN`, and `--cap-add=NET_RAW` are required to allow the container to access the host's network interface.

- **DNS Query with `dig`:**

  ```bash
  docker run lanyard dig example.com
  ```

- **SSH Connection with `ssh`:**

  ```bash
  docker run lanyard ssh user@host
  ```

## Contribution

Contributions are welcome! Feel free to open issues or pull requests with improvements, fixes, or new features.

## License

This project is licensed under the [MIT License](LICENSE).
```

---

## Project Files

In addition to the `README.md`, make sure your repository contains the following files:

### 1. Dockerfile

```dockerfile
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
```

### 2. entrypoint.sh

```bash
#!/bin/sh

# If no arguments are provided, start an interactive shell
if [ "$#" -eq 0 ]; then
    exec /bin/sh
else
    # Execute the provided command
    exec "$@"
fi
```

### 3. LICENSE

Add a `LICENSE` file to your repository. If you choose the MIT License, include the appropriate text.

---

## Additional Tips

- **Docker Hub:** If you publish the image on Docker Hub or another container registry, include instructions on how to pull the image:

  ```bash
  docker pull your_dockerhub_username/lanyard
  ```

- **Updates:** Keep the `README.md` updated as you add new tools or features.

- **Issues and Support:** Indicate how users can report problems or request support.

---

## Conclusion

**Lanyard** is a practical solution for anyone who needs a comprehensive set of networking tools in a portable and easy-to-use environment. With this `README.md`, you provide users with all the necessary information to effectively use the image.

