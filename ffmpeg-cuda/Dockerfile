ARG FFMPEG_VERSION=5.1

# Build the FFmpeg-build image.
FROM nvidia/cuda:11.0.3-devel-ubuntu18.04 as builder-ffmpeg

ENV DEBIAN_FRONTEND=noninteractive
ARG FFMPEG_VERSION
ARG PREFIX=/usr/local
ARG MAKEFLAGS="-j 8"

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    yasm \
    cmake \
    git \
    libtool \
    libc6 \
    libc6-dev \
    unzip \
    wget \
    libnuma1 \
    libnuma-dev \
    pkg-config && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# Clone and install ffnvcodec
RUN git clone --branch sdk/8.1 https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && \
    cd nv-codec-headers && \
    make install && \
    cd -

# Get FFmpeg source.
RUN wget http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && \
    tar zxf ffmpeg-${FFMPEG_VERSION}.tar.gz && \
    rm ffmpeg-${FFMPEG_VERSION}.tar.gz

# Compile ffmpeg.
WORKDIR /tmp/ffmpeg-${FFMPEG_VERSION}
RUN ./configure \
    --prefix=${PREFIX} \
    --enable-nonfree \
    --enable-cuda-nvcc \
    --enable-libnpp \
    --extra-cflags=-I/usr/local/cuda/include \
    --extra-ldflags=-L/usr/local/cuda/lib64 \
    --disable-static \
    --enable-shared && \
    make && \
    make install && \
    make distclean

# Cleanup.
RUN rm -rf /var/cache/* /tmp/*

# Build the release image.
FROM nvidia/cuda:11.0.3-devel-ubuntu18.04
LABEL MAINTAINER xiaomao23zhi <github.com/xiaomao23zhi>

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_DRIVER_VERSION=450
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,video,utility

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder-ffmpeg /usr/local /usr/local
