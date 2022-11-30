ARG FFMPEG_VERSION=5.1

FROM nvidia/cuda:11.0.3-devel-ubuntu18.04

ENV DEBIAN_FRONTEND=noninteractive
ARG FFMPEG_VERSION=5.1
ARG PREFIX=/usr/local
ARG MAKEFLAGS="-j 8"

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    libx264-dev \
    libx265-dev \
    libtool \
    libc6 \
    libc6-dev  \
    libfreetype6-dev \
    libfdk-aac-dev \
    libmp3lame-dev \
    libogg-dev \
    libnuma1 \
    libnuma-dev \
    git \
    openssl \
    yasm \
    unzip \
    wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# ffnvcodec
RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && \
    cd nv-codec-headers && \
    make install && \
    cd -

# ffmpeg
RUN wget http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && \
    tar zxf ffmpeg-${FFMPEG_VERSION}.tar.gz && \
    rm ffmpeg-${FFMPEG_VERSION}.tar.gz
WORKDIR /tmp/ffmpeg-${FFMPEG_VERSION}
RUN ./configure \
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
