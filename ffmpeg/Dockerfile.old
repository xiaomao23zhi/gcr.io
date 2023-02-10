ARG FFMPEG_VERSION=5.1

# Build the FFmpeg-build image.
FROM nvidia/cuda:10.1-devel-ubuntu18.04 as builder-ffmpeg

ENV DEBIAN_FRONTEND=noninteractive
ARG FFMPEG_VERSION=5.1
ARG PREFIX=/usr/local
ARG MAKEFLAGS="-j 8"

RUN apt update && apt install -y --no-install-recommends \
    build-essential \
    coreutils \
    cmake \
    libx264-dev \
    libx265-dev \
    libc6 \
    libc6-dev \
    libfreetype6-dev \
    libfdk-aac-dev \
    libmp3lame-dev \
    libogg-dev \
    libass9 \
    libass-dev \
    libnuma1 \
    libnuma-dev \
    libopus-dev \
    librtmp-dev \
    libvpx-dev \
    libvorbis-dev \
    libwebp-dev \
    libtheora-dev \
    libtool \
    libssl-dev \
    pkg-config \
    wget \
    yasm \
    git \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# Clone and install ffnvcodec
RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && \
    cd nv-codec-headers && \
    make install

# Get FFmpeg source.
RUN wget http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && \
    tar zxf ffmpeg-${FFMPEG_VERSION}.tar.gz && \
    rm ffmpeg-${FFMPEG_VERSION}.tar.gz

# Compile ffmpeg.
WORKDIR /tmp/ffmpeg-${FFMPEG_VERSION}
RUN \
    ./configure \
    --prefix=${PREFIX} \
    --enable-version3 \
    --enable-gpl \
    --enable-nonfree \
    --enable-small \
    --enable-libfdk-aac \
    --enable-openssl \
    --enable-libnpp \
    --enable-cuda \
    --enable-cuvid \
    --enable-nvenc \
    --enable-libnpp \
    --disable-debug \
    --disable-doc \
    --disable-ffplay \
    --extra-cflags=-I/usr/local/cuda/include \
    --extra-ldflags=-L/usr/local/cuda/lib64 \
    --extra-libs="-lpthread -lm" && \
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

RUN apt update && apt install -y --no-install-recommends \
    ca-certificates \
    curl \
    gettext \
    libpcre3-dev \
    libnvidia-decode-${NVIDIA_DRIVER_VERSION} \
    libnvidia-encode-${NVIDIA_DRIVER_VERSION} \
    libtheora0 \
    openssl && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder-ffmpeg /usr/local /usr/local
COPY --from=builder-ffmpeg /usr/lib/x86_64-linux-gnu/libfdk-aac.so.1 /usr/lib/x86_64-linux-gnu/libfdk-aac.so.1
