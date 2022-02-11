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
RUN wget https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/${CUDA_DEB} && \
    dpkg -i ${CUDA_DEB} && \
    apt-key add /var/cuda-repo-10-1-local-10.1.105-418.39/7fa2af80.pub && \
    apt-get update && \
    apt-get -y install cuda-libraries-10-1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf ${CUDA_DEB}

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
    xgboost && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Install tensorflow
RUN pip install --no-cache-dir \
    keras \
    tensorflow \
    tensorflow-gpu && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Install pytorch
RUN conda install \
    pytorch \
    torchvision \
    torchaudio \
    cudatoolkit=10.1 \
    -c pytorch && \
    conda clean --all -f -y

# Install tensorboard
RUN pip install --no-cache-dir git+https://github.com/cliffwoolley/jupyter_tensorboard.git && \
    pip install --no-cache-dir git+https://github.com/chaoleili/jupyterlab_tensorboard.git

# clean up
RUN rm -rf ~/.cache/pip ~/.cache/yarn

# Dask Scheduler & Bokeh ports
EXPOSE 8787
EXPOSE 8786

WORKDIR "${HOME}"

USER $NB_UID
