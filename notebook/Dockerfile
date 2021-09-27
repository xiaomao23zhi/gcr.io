FROM jupyter/all-spark-notebook:spark-3.1.1

MAINTAINER xiaomao23zhi <https://github.com/xiaomao23zhi/>

ARG PROFILE=cicd
ENV NB_USER=jovyan

# Install packages
USER root
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    graphviz \
    language-pack-zh-hans && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER $NB_UID

# Install sparkmagic
RUN pip install sparkmagic && \
    jupyter-kernelspec install --user $(pip show sparkmagic | grep Location | cut -d" " -f2)/sparkmagic/kernels/sparkkernel && \
    jupyter-kernelspec install --user $(pip show sparkmagic | grep Location | cut -d" " -f2)/sparkmagic/kernels/pysparkkernel && \
    jupyter serverextension enable --py sparkmagic
RUN mkdir /home/$NB_USER/.sparkmagic
COPY ./sparkmagic-config-$PROFILE.json /home/$NB_USER/.sparkmagic/config.json

# Fix font
COPY ./simhei.ttf /opt/conda/lib/python3.8/site-packages/matplotlib/mpl-data/fonts/ttf/simhei.ttf

# Install dask
RUN conda create --name dask --clone base && \
    source activate dask
RUN pip install --ignore-installed llvmlite \
    nbconvert==5.6.1 \
    dask==2021.6.0 \
    distributed==2021.6.0 \
    dask-gateway==0.9.0 \
    dask-ml \
    msgpack==1.0.2 \
    && \
    python -m ipykernel install --user --name dask --display-name "Dask"

RUN rm -rf ~/.cache/pip ~/.cache/yarn

USER $NB_UID
