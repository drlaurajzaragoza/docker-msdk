
# Maxim SDK Docker Image

![Docker Image CI](https://github.com/cnuahs/docker-msdk/actions/workflows/build-docker.yml/badge.svg)
![GitHub release](https://img.shields.io/github/v/tag/cnuahs/docker-msdk)
![ghcr.io](https://img.shields.io/badge/ghcr.io-enabled-brightgreen)

This repository builds and publishes a minimal Docker image containing [only] the [Analog Devices](https://www.analog.com/en/index.html) Maxim Microcontrollers SDK ([MSDK](https://github.com/analogdevicesinc/msdk/)). The image is designed to speed up building dev containers (or other Docker images) for building, flashing, and testing applications targeting Analog Device's MAX-series ([MAX32xxx and MAX78xxx](https://www.analog.com/en/parametricsearch/10984#/)) microcontrollers.

## Docker Image

The image is published to the [GitHub Container Registry (GHCR)](https://ghcr.io) as:

```
ghcr.io/cnuahs/msdk
```

## Image Contents

This image contains:

- **Only** the files installed by the official [Analog Devices MSDK](https://github.com/analogdevicesinc/msdk/) installer
- No shell, no tools, no system utilities

This image is **not** a runnable container and is not meant to be executed directly (e.g., via `docker run ...`). The image is designed to speed up building dev containers (or other Docker images):

```dockerfile
ARG MSDK_VER

FROM ghcr.io/cnuahs/msdk:${MSDK_VER} AS msdk

FROM ubuntu:24.04 AS base

# add build tools, scripts, or application logic here

# add the Maxim SDK... 
ARG MAXIM_PATH
ENV MAXIM_PATH=${MAXIM_PATH:-/opt/msdk/${MSDK_VER}}

COPY --from=msdk --link msdk/ ${MAXIM_PATH}
# RUN chown -R ${USER}:${USER} ${MAXIM_PATH}
```

For a complete dev container built using this image see [msdk-devcontainer.git](https://github.com/cnuahs/msdk-devcontainer.git/).

## Rebuilding the Image

To build the image locally:

```bash
git clone https://github.com/cnuahs/docker-msdk.git
cd docker-msdk
docker build -t msdk .
```

## License

This Dockerfile and build environment are provided under the MIT License.  
The Analog Devices MSDK itself is licensed separately; refer to its [LICENSE](https://github.com/analogdevicesinc/msdk/).

## Feedback & Contributions

Issues and PRs are welcome! If you encounter any problems or want to contribute improvements, feel free to open an issue or submit a pull request.
