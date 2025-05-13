# syntax=docker/dockerfile:1

# 2025-05-13 - Shaun L. Cloherty <s.cloherty@ieee.org>

ARG MSDK_VER=v2024_10

################################################################
FROM ubuntu:24.04 AS build

# install build dependencies etc.
RUN <<EOF
    echo "deb http://security.ubuntu.com/ubuntu focal-security main universe" > \
        /etc/apt/sources.list.d/ubuntu-focal-sources.list
EOF

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential ca-certificates make \
        libusb-0.1-4 libhidapi-libusb0 libhidapi-hidraw0 \
        libfontconfig1 \
        libdbus-1-3 \
        libx11-xcb1 \
        libxcb-glx0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 \
        libxcb-shape0 libxcb-sync1 libxcb-xfixes0 libxcb-xinerama0 libxcb-xkb1 libxext6 libxkbcommon-x11-0 \
        libgl1 libglx-mesa0 \
        libncurses5 curl && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

# download/install Maxim SDK

ARG MSDK_VER
ENV MSDK_URL=https://github.com/analogdevicesinc/msdk/releases/download/${MSDK_VER}/MaximMicrosSDK_linux.run

RUN --mount=type=cache,target=/root/.cache <<EOF
    if [ ! -d /msdk ]; then
        mkdir -p /msdk
        cd /tmp
        curl -L ${MSDK_URL} -o MaximMicrosSDK_linux.run && \
        chmod +x MaximMicrosSDK_linux.run

        if [ ! -d /usr/share/applications ]; then
            mkdir -p /usr/share/applications
        fi

        ./MaximMicrosSDK_linux.run in --root /msdk --accept-licenses --accept-messages --confirm-command
    fi
EOF

################################################################
FROM scratch AS msdk

# copy Maxim SDK
COPY --from=build --link /msdk /msdk

# ENTRYPOINT ["/msdk"]
