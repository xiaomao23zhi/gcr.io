FROM jupyter/pyspark-notebook:24da256d4ed9

MAINTAINER xiaomao23zhi <https://github.com/xiaomao23zhi/>

ARG PROFILE=cicd
ENV NB_USER=jovyan

# Install packages
USER root
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    graphviz \
    language-pack-zh-hans \
    fonts-dejavu \
    unixodbc \
    unixodbc-dev \
    r-cran-rodbc \
    gfortran \
    gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Fix for devtools https://github.com/conda-forge/r-devtools-feedstock/issues/4
RUN ln -s /bin/tar /bin/gtar

USER $NB_UID

# Install sparkmagic
RUN pip install sparkmagic && \
    jupyter nbextension enable --py --sys-prefix widgetsnbextension && \
    jupyter labextension install "@jupyter-widgets/jupyterlab-manager" && \
    jupyter labextension install jupyterlab-plotly && \
    jupyter-kernelspec install --user $(pip show sparkmagic | grep Location | cut -d" " -f2)/sparkmagic/kernels/sparkkernel && \
    jupyter-kernelspec install --user $(pip show sparkmagic | grep Location | cut -d" " -f2)/sparkmagic/kernels/pysparkkernel && \
    jupyter serverextension enable --py sparkmagic
RUN mkdir /home/$NB_USER/.sparkmagic
COPY ./sparkmagic-config-$PROFILE.json /home/$NB_USER/.sparkmagic/config.json

# Fix font
COPY ./simhei.ttf /opt/conda/lib/python3.8/site-packages/matplotlib/mpl-data/fonts/ttf/simhei.ttf

USER root
# Install R
RUN conda install --quiet --yes \
    'r-base=3.6.3' \
    'r-caret=6.0*' \
    'r-crayon=1.3*' \
    'r-devtools=2.3*' \
    'r-forecast=8.12*' \
    'r-hexbin=1.28*' \
    'r-htmltools=0.4*' \
    'r-htmlwidgets=1.5*' \
    'r-irkernel=1.1*' \
    'r-nycflights13=1.0*' \
    'r-plyr=1.8*' \
    'r-randomforest=4.6*' \
    'r-rcurl=1.98*' \
    'r-reshape2=1.4*' \
    'r-rmarkdown=2.1*' \
    'r-rodbc=1.3*' \
    'r-rsqlite=2.2*' \
    'r-shiny=1.4*' \
    'r-tidyverse=1.3*' \
    'unixodbc=2.3.*' \
    && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}"

# Install e1071 R package (dependency of the caret R package)
RUN conda install --quiet --yes r-e1071
RUN Rscript -e "install.packages('igraph')"

# Install dask
RUN conda create --name dask --offline && \
    source activate dask
RUN pip install --ignore-installed llvmlite \
    nbconvert==5.6.1 \
    dask==2021.6.0 \
    distributed==2021.6.0 \
    dask-gateway==0.9.0 \
    dask-ml \
    msgpack==1.0.2 \
    && \
    python -m ipykernel install --name dask --display-name "Dask"

RUN rm -rf ~/.cache/pip ~/.cache/yarn

USER $NB_UID
