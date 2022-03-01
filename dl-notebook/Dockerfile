FROM jupyter/datascience-notebook:2021-11-10

MAINTAINER xiaomao23zhi <https://github.com/xiaomao23zhi/>

USER root

# Install packages
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    graphviz \
    julia \
    gnupg2 \
    language-pack-zh-hans && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install CUDA
ENV CUDA_VERSION 10.1.105
ENV CUDA_PKG_VERSION 10-1
ENV NCCL_VERSION 2.7.8
ENV CUDNN_VERSION 7.6.5.32

WORKDIR /tmp

RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    cuda-toolkit-10-1=10.1.105-1 \
    libcublas10=10.1.0.105-1 \
    libcublas-dev=10.1.0.105-1 && \
    apt-mark hold libcublas10 libcublas-dev && \
    rm -rf /var/lib/apt/lists/*
#ARG CUDA_DEB=cuda-repo-ubuntu1804-10-1-local-10.1.105-418.39_1.0-1_amd64.deb
#
#RUN wget --quiet https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/${CUDA_DEB} && \
#    dpkg -i ${CUDA_DEB} && \
#    apt-key add /var/cuda-repo-10-1-local-10.1.105-418.39/7fa2af80.pub && \
#    apt-get update && \
#    apt-get install --yes --no-install-recommends \
#    cuda-toolkit-10-1 \
#    cuda-compat-10-1 \
#    && \
#    apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf ${CUDA_DEB}

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# nvidia-container-runtime
ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin${PATH:+:${PATH}}
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_REQUIRE_CUDA="cuda>=10.1 brand=tesla,driver>=418,driver<419"

# Install cuDNN
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn7=$CUDNN_VERSION-1+cuda10.1 \
    libcudnn7-dev=$CUDNN_VERSION-1+cuda10.1 && \
    apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*

# Install TensorRT
RUN apt-get update && apt-get install -y --no-install-recommends \
    libnvinfer6=6.0.1-1+cuda10.1 \
    libnvinfer-dev=6.0.1-1+cuda10.1 \
    libnvinfer-plugin6=6.0.1-1+cuda10.1

## Fix gnupg
#RUN chown -R ${NB_UID}:${NB_GID} ~/.gnupg

ARG PYTHON_VERSION=3.7
ARG TENSORFLOW_ENV=tf2.1
ARG PYTORCH_ENV=pt1.8

# Install tensorflow
RUN mamba create --quiet --yes -p "${CONDA_DIR}/envs/${TENSORFLOW_ENV}" python=${PYTHON_VERSION} ipython ipykernel && \
    mamba clean --all -f -y
RUN "${CONDA_DIR}/envs/${TENSORFLOW_ENV}/bin/python" -m ipykernel install --name="${TENSORFLOW_ENV}" --display-name="Tensorflow 2.1" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
RUN "${CONDA_DIR}/envs/${TENSORFLOW_ENV}/bin/pip" install --quiet --no-cache-dir \
    keras \
    tensorflow==2.1.0 && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
COPY ./logo/tensorflow-logo-64x64.png /usr/local/share/jupyter/kernels/${TENSORFLOW_ENV}/logo-64x64.png

# Install pytorch
RUN mamba create --quiet --yes -p "${CONDA_DIR}/envs/${PYTORCH_ENV}" python=${PYTHON_VERSION} ipython ipykernel && \
    mamba clean --all -f -y
RUN "${CONDA_DIR}/envs/${PYTORCH_ENV}/bin/python" -m ipykernel install --name="${PYTORCH_ENV}" --display-name="Pytorch 1.8" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
RUN "${CONDA_DIR}/envs/${PYTORCH_ENV}/bin/pip" install --quiet --no-cache-dir \
    torch==1.8.1+cu101 \
    torchvision==0.9.1+cu101 \
    -f https://download.pytorch.org/whl/cu101/torch_stable.html && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
COPY ./logo/pytorch-logo-64x64.png /usr/local/share/jupyter/kernels/${PYTORCH_ENV}/logo-64x64.png

USER ${NB_USER}

# Add user-settings
COPY --chown=${NB_UID}:${NB_GID} user-settings/ /home/jovyan/.jupyter/lab/user-settings/

# Python packages
RUN pip install --no-cache-dir \
    jupyterlab_execute_time \
    jupyter-resource-usage \
    jupyterlab-system-monitor \
    jupyterlab-lsp \
    jupyterlab-nvdashboard \
    python-lsp-server[all] \
    papermill && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Install tensorboard
RUN pip install --no-cache-dir git+https://github.com/cliffwoolley/jupyter_tensorboard.git && \
    pip install --no-cache-dir git+https://github.com/chaoleili/jupyterlab_tensorboard.git

# clean up
RUN rm -rf ~/.cache/pip ~/.cache/yarn

WORKDIR "${HOME}"

USER ${NB_USER}
