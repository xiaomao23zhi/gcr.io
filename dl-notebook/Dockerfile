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
WORKDIR /tmp
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl && \
    rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 10.1.105
ENV CUDA_PKG_VERSION 10-1
ENV NCCL_VERSION 2.7.8
ENV CUDNN_VERSION 7.6.5.32

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-$CUDA_PKG_VERSION \
    cuda-compat-10-1=418.39-1 \
    cuda-libraries-$CUDA_PKG_VERSION \
    cuda-nvtx-$CUDA_PKG_VERSION \
    libnccl2=$NCCL_VERSION-1+cuda10.1 && \
    apt-mark hold libnccl2 && \
    ln -s cuda-10.1 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# nvidia-container-runtime
ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda-10.1/bin${PATH:+:${PATH}}
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

ARG tf_env=tensorflow
ARG tc_env=pytorch
ARG py_ver=3.7

# Install tensorflow
RUN mamba create --quiet --yes -p "${CONDA_DIR}/envs/${tf_env}" python=${py_ver} ipython ipykernel && \
    mamba clean --all -f -y
RUN "${CONDA_DIR}/envs/${tf_env}/bin/python" -m ipykernel install --user --name="${tf_env}" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
RUN "${CONDA_DIR}/envs/${tf_env}/bin/pip" install --quiet --no-cache-dir \
    keras \
    tensorflow==2.1.0
COPY ./logo/tensorflow-logo-64x64.png /home/jovyan/.local/share/jupyter/kernels/tensorflow/logo-64x64.png

# Install pytorch
RUN mamba create --quiet --yes -p "${CONDA_DIR}/envs/${tc_env}" python=${py_ver} ipython ipykernel && \
    mamba clean --all -f -y
RUN "${CONDA_DIR}/envs/${tc_env}/bin/python" -m ipykernel install --user --name="${tc_env}" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
RUN "${CONDA_DIR}/envs/${tc_env}/bin/pip" install --quiet --no-cache-dir \
    torch==1.8.1+cu101 \
    torchvision==0.9.1+cu101 \
    -f https://download.pytorch.org/whl/cu101/torch_stable.html
COPY ./logo/pytorch-logo-64x64.png /home/jovyan/.local/share/jupyter/kernels/pytorch/logo-64x64.png

# Install tensorboard
RUN pip install --no-cache-dir git+https://github.com/cliffwoolley/jupyter_tensorboard.git && \
    pip install --no-cache-dir git+https://github.com/chaoleili/jupyterlab_tensorboard.git

# clean up
RUN rm -rf ~/.cache/pip ~/.cache/yarn

WORKDIR "${HOME}"

USER ${NB_USER}
