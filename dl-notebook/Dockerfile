FROM jupyter/tensorflow-notebook:2021-11-10

MAINTAINER xiaomao23zhi <https://github.com/xiaomao23zhi/>

ARG CUDA_DEB=cuda-repo-ubuntu1804-10-1-local-10.1.105-418.39_1.0-1_amd64.deb

USER root

# Install packages
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    graphviz \
    julia \
    gnupg2 \
    language-pack-zh-hans && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
 
# Fix font
COPY --chown=${NB_UID}:${NB_GID} ./simhei.ttf /opt/conda/lib/python3.9/site-packages/matplotlib/mpl-data/fonts/ttf/simhei.ttf

# Install CUDA
WORKDIR /tmp
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl && \
    rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 10.1.105 \
    CUDA_PKG_VERSION 10-1=$CUDA_VERSION-1 \
    CUDNN_VERSION 7.5.0.56
RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-cudart-$CUDA_PKG_VERSION \
        cuda-compat-10-1=418.39-1 \
        cuda-libraries-$CUDA_PKG_VERSION \
        cuda-nvtx-$CUDA_PKG_VERSION \
        libnccl2=$NCCL_VERSION-1+cuda10.1 \
        && \
    apt-mark hold libnccl2 && \
    ln -s cuda-10.1 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# nvidia-container-runtime
ENV PATH=/usr/local/cuda-10.1/bin${PATH:+:${PATH}} \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility \
    NVIDIA_REQUIRE_CUDA="cuda>=10.1 brand=tesla,driver>=418,driver<419"

# Install cuDNN
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"
RUN apt-get update && apt-get install -y --no-install-recommends \
            libcudnn7=$CUDNN_VERSION-1+cuda10.1 && \
    apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*
    
# Fix gnupg
RUN chown -R ${NB_UID}:${NB_GID} ~/.gnupg

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
    papermill \
    && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Install tensorflow
RUN conda create --name tensorflow && \
    source activate tensorflow \
RUN pip install --no-cache-dir \
    keras \
    tensorflow \
    tensorflow-gpu \
    && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}" && \
    python -m ipykernel install --user --name tensorflow --display-name "Tensorflow" \
COPY ./logo/tensorflow-logo-64x64.png /home/jovyan/.local/share/jupyter/kernels/tensorflow/logo-64x64.png

# Install pytorch
RUN conda create --name pytorch && \
    source activate pytorch \
RUN conda install \
    pytorch \
    torchvision \
    torchaudio \
    cudatoolkit=11.0 \
    -c pytorch && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}" && \
    python -m ipykernel install --user --name pytorch --display-name "PyTorch" \
COPY ./logo/pytorch-logo-64x64.png /home/jovyan/.local/share/jupyter/kernels/pytorch/logo-64x64.png

# Install tensorboard
RUN pip install --no-cache-dir git+https://github.com/cliffwoolley/jupyter_tensorboard.git && \
    pip install --no-cache-dir git+https://github.com/chaoleili/jupyterlab_tensorboard.git

# clean up
RUN rm -rf ~/.cache/pip ~/.cache/yarn

WORKDIR "${HOME}"

USER ${NB_USER}
