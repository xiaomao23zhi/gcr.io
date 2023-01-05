FROM nvcr.io/nvidia/deepstream:6.1.1-devel

# Base dependencies
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    python3-gi \
    python3-dev \
    python3-gst-1.0 \
    python-gi-dev \
    git \
    python-dev \
    python3 \
    python3-pip \
    python3.8-dev \
    cmake \
    g++ \
    build-essential \
    libglib2.0-dev \
    libglib2.0-dev-bin \
    libgstreamer1.0-dev \
    libtool \
    m4 \
    autoconf \
    automake \
    libgirepository1.0-dev \
    libcairo2-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/nvidia/deepstream/deepstream-6.1/sources

# Initialization of submodules
RUN git clone https://github.com/NVIDIA-AI-IOT/deepstream_python_apps && \
    cd deepstream_python_apps/ && \
    git submodule update --init

# Installing Gst-python
RUN apt-get install --yes --no-install-recommends \
    apt-transport-https \
    ca-certificates && \
    update-ca-certificates
RUN cd deepstream_python_apps/3rdparty/gst-python/ && \
    ./autogen.sh && \
    make && \
    make install

# Compiling the bindings
RUN cd deepstream_python_apps/bindings && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make

# # Installing the bindings
# RUN cd deepstream_python_apps/bindings && \
#     pip3 install ./pyds-1.1.4-py3-none*.whl