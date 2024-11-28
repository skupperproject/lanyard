# Lanyard - A Versatile Networking Toolkit Docker Image

**Lanyard** is a Docker image based on Alpine Linux that includes a comprehensive set of networking tools along with a simple Flask API. This image allows you to either run the Flask application or execute any of the included networking utilities directly.

## Table of Contents

- [Included Tools](#included-tools)
- [Getting Started](#getting-started)
  - [Running the Flask API](#running-the-flask-api)
  - [Running Networking Tools](#running-networking-tools)
- [Flask Application](#flask-application)
- [Building the Docker Image Locally](#building-the-docker-image-locally)
- [Usage Examples](#usage-examples)
- [Notes](#notes)

## Included Tools

The Docker image includes the following tools:

- `curl`
- `traceroute`
- `openssl`
- `iperf`
- `wget`
- `busybox-extras`
- `nmap`
- `netcat-openbsd`
- `tcpdump`
- `mtr`
- `socat`
- `bind-tools`
- `iproute2`
- `openssh-client`
- `python3`
- `procps`
- `coreutils`
- `mongodb-tools`
- `postgresql-client`
- `py3-flask`
- **Go** (installed minimally)

## Getting Started

### Running the Flask API

To run the Flask API, execute the following command:

```sh
docker run --rm -d -p 5000:5000 quay.io/rzago/lanyard:latest
```

- `--rm`: Automatically removes the container when it exits.
- `-d`: Runs the container in detached mode.
- `-p 5000:5000`: Maps port 5000 of the host to port 5000 of the container.

Once the container is running, you can access the API at [http://localhost:5000/](http://localhost:5000/). You should see the message:

```
Hello, World from Lanyard!
```

### Running Networking Tools

You can overwrite the default command (`CMD`) to run any of the available networking tools included in the image. For example, to run `ping`:

```sh
docker run --rm quay.io/rzago/lanyard:latest ping -c 4 google.com
```

Sample output:

```
PING google.com (142.250.79.14): 56 data bytes
64 bytes from 142.250.79.14: seq=0 ttl=116 time=7.264 ms
64 bytes from 142.250.79.14: seq=1 ttl=116 time=7.509 ms
64 bytes from 142.250.79.14: seq=2 ttl=116 time=7.231 ms
64 bytes from 142.250.79.14: seq=3 ttl=116 time=7.189 ms

--- google.com ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 7.189/7.298/7.509 ms
```

## Flask Application

The Flask application (`app.py`) included in the image is a simple "Hello World" app:

```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World from Lanyard!'

if __name__ == '__main__':
    app.run(host='0.0.0.0')
```

## Building the Docker Image Locally

If you prefer to build the Docker image locally, use the provided `Dockerfile`:

```dockerfile
FROM alpine:latest

# Install base tools
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

# Expose port 5000 for the Flask app
EXPOSE 5000

# Default command to run the Flask app
CMD ["python3", "/app.py"]
```

**Build the image:**

```sh
docker build -t lanyard .
```

## Usage Examples

Here are some examples of how to use the Docker image to run various networking tools.

### Run `ping`

```sh
docker run --rm lanyard ping -c 4 google.com
```

### Run `traceroute`

```sh
docker run --rm lanyard traceroute google.com
```

### Run `curl`

```sh
docker run --rm lanyard curl -I https://www.google.com
```

### Run `nmap`

```sh
docker run --rm lanyard nmap -sV google.com
```

### Run `iperf`

```sh
# As an iperf server
docker run --rm -p 5201:5201 lanyard iperf -s

# As an iperf client
docker run --rm lanyard iperf -c <server_ip>
```

## Notes

- **Default Behavior:** If no command is specified, the container will run the Flask API.
- **Overriding the Command:** You can run any of the included tools by specifying the command after the image name.
- **Exposed Ports:** Ensure that the ports you intend to use are not blocked by your firewall or used by other applications.
- **Networking:** When running networking tools, you might need to adjust Docker's network settings depending on your environment.
- **Alpine Linux:** The image is based on Alpine Linux for a minimal footprint.

---

Feel free to contribute or raise issues if you encounter any problems. Enjoy using Lanyard for all your networking needs!