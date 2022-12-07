ARG FFMPEG_VERSION=5.1

# Build the FFmpeg-build image.
FROM nvidia/cuda:11.0.3-devel-ubuntu18.04 as builder-ffmpeg

ENV DEBIAN_FRONTEND=noninteractive
ARG FFMPEG_VERSION=5.1
ARG PREFIX=/usr/local
ARG MAKEFLAGS="-j 8"

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git-core \
    libass-dev \
    libfreetype6-dev \
    libgnutls28-dev \
    libmp3lame-dev \
    libsdl2-dev \
    libva-dev \
    libvdpau-dev \
    libvorbis-dev \
    libxcb1-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    libtool \
    libc6 \
    libc6-dev \
    libnuma1 \
    libnuma-dev \
    libx264-dev \
    libx265-dev \
    pkg-config \
    unzip \
    wget \
    yasm \
    zliblg-dev && \
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
    --extra-cflags=-I/usr/local/cuda/include \
    --extra-ldflags=-L/usr/local/cuda/lib64 \
    --extra-libs="-lpthread -lm" \
    --enable-nonfree \
    --enable-gpl \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    --enable-cuda-nvcc \
    --enable-cuda-llvm \
    --enable-cuda \
    --enable-cuvid \
    --enable-nvenc \
    --enable-libnpp \
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
    curl \
    openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder-ffmpeg /usr/local /usr/local