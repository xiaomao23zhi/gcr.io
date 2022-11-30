FROM nvidia/cuda:11.0.3-devel-ubuntu18.04

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

RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && \
    cd nv-codec-headers && sudo make install && cd –