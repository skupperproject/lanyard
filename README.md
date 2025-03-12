Here's the updated README that includes both the new HTTP/2 examples and the original `ping` example:

---

# Lanyard - A Versatile Networking Toolkit Docker Image

**Lanyard** is a Docker image based on Alpine Linux that includes a comprehensive set of networking tools and a lightweight Nginx server with HTTPS and HTTP/2 support. This image allows you to serve static files securely or execute any of the included networking utilities directly.

## Table of Contents

- [Included Tools](#included-tools)
- [Getting Started](#getting-started)
  - [Running Nginx](#running-nginx)
  - [Running Networking Tools](#running-networking-tools)
- [Nginx Configuration](#nginx-configuration)
- [HTTP/2 Support](#http2-support)
- [Building the Docker Image Locally](#building-the-docker-image-locally)
- [Usage Examples](#usage-examples)
- [Notes](#notes)

## Included Tools

The Docker image includes the following tools:

- `bash`
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
- **Go** (installed minimally)
- `nginx`
- `oha`
- `redis`

## Getting Started

### Running Nginx

To run the Nginx server:

```sh
docker run --rm -d -p 8080:8080 quay.io/rzago/lanyard:latest
```

- `--rm`: Automatically removes the container when it exits.
- `-d`: Runs the container in detached mode.
- `-p 8080:8080`: Maps port 8080 of the host to port 8080 of the container.

Once the container is running, you can access the server at [http://localhost:8080](http://localhost:8080). You will see the response:

```
<h1>Hello from Lanyard</h1>
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

## Nginx Configuration

### Default Configuration

- **HTTP/2 and HTTP/1.1:** Nginx supports both HTTP/2 and HTTP/1.1. 
- **Static Files:** Static files are served from `/usr/share/nginx/html`.

### Custom Configuration

You can mount custom Nginx configuration files to modify the server's behavior:

```sh
docker run --rm -d -p 8080:8080 -v $(pwd)/my-nginx.conf:/etc/nginx/nginx.conf quay.io/rzago/lanyard:latest
```

## HTTP/2 Support

Nginx in the Lanyard image supports HTTP/2. Below are examples demonstrating HTTP/2 and HTTP/1.1 behavior:

#### Testing HTTP/2

```sh
curl --http2 --http2-prior-knowledge http://localhost:8080
```

Output:

```html
<h1>Hello from Lanyard</h1>
```

#### Testing HTTP/1.1

```sh
curl http://localhost:8080
```

Output:

```html
<h1>Hello from Lanyard</h1>
```

#### Inspecting HTTP Headers (HTTP/1.1)

```sh
curl -I http://localhost:8080
```

Output:

```
HTTP/1.1 200 OK
Server: nginx/1.26.2
Date: Mon, 06 Jan 2025 18:06:29 GMT
Content-Type: text/html
Content-Length: 29
Last-Modified: Mon, 06 Jan 2025 18:06:06 GMT
Connection: keep-alive
ETag: "677c1b8e-1d"
Accept-Ranges: bytes
```

#### Inspecting HTTP Headers (HTTP/2)

```sh
curl -I --http2 --http2-prior-knowledge http://localhost:8080
```

Output:

```
HTTP/2 200
server: nginx/1.26.2
date: Mon, 06 Jan 2025 18:06:39 GMT
content-type: text/html
content-length: 29
last-modified: Mon, 06 Jan 2025 18:06:06 GMT
etag: "677c1b8e-1d"
accept-ranges: bytes
```

## Building the Docker Image Locally

If you prefer to build the Docker image locally, use the provided `Dockerfile`:

```sh
docker build -t lanyard .
```

## Usage Examples

### Run `ping`

```sh
docker run --rm lanyard ping -c 4 google.com
```

### Serve Custom Static Files

Mount a directory containing your static files:

```sh
docker run --rm -d -p 8080:8080 -v $(pwd)/html:/usr/share/nginx/html quay.io/rzago/lanyard:latest
```

---

Feel free to contribute or raise issues if you encounter any problems. Enjoy using Lanyard for all your networking and lightweight web-serving needs!
