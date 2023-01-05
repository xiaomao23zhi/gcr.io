FROM nvcr.io/nvidia/deepstream:5.0-20.07-devel

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    python-gi-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV GST_LIBS="-lgstreamer-1.0 -lgobject-2.0 -lglib-2.0"
ENV GST_CFLAGS="-pthread -I/usr/include/gstreamer-1.0 -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include"

RUN git clone https://github.com/GStreamer/gst-python.git && \
    cd gst-python && \
    git checkout 1a8f48a && \
    ./autogen.sh PYTHON=python3 && \
    ./configure PYTHON=python3 && \
    make && \
    make install

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    libgstrtspserver-1.0-0 gstreamer1.0-rtsp \
    libgirepository1.0-dev \
    gobject-introspection gir1.2-gst-rtsp-server-1.0 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*