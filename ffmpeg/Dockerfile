ARG FFMPEG_VERSION
ARG JDK_VERSION

FROM docker pull nvidia/cuda:11.0.3-devel-ubuntu18.04 as builder-ffmpeg
RUN apt update && apt install -y --no-install-recommends \
    build-essential \
    cmake \
    libtool \
    libc6 \
    libc6-dev  \
    libnuma1 \
    libnuma-dev \
    yasm \
    unzip \
    wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

