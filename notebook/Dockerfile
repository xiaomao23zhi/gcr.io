FROM jupyter/all-spark-notebook:6f4cbae746cd

MAINTAINER xiaomao23zhi <https://github.com/xiaomao23zhi/>

ARG PROFILE=cicd

# Install packages
USER root
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    graphviz \
    language-pack-zh-hans && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER $NB_UID

# Add user-settings
COPY --chown=${NB_UID}:${NB_GID} user-settings/ /home/jovyan/.jupyter/lab/user-settings/

# Install from requirements.txt file
COPY --chown=${NB_UID}:${NB_GID} requirements.txt /tmp/
RUN pip install --no-cache-dir --requirement /tmp/requirements.txt && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# # Install sparkmagic
# RUN jupyter-kernelspec install --user $(pip show sparkmagic | grep Location | cut -d" " -f2)/sparkmagic/kernels/sparkkernel && \
#     jupyter-kernelspec install --user $(pip show sparkmagic | grep Location | cut -d" " -f2)/sparkmagic/kernels/pysparkkernel && \
#     jupyter serverextension enable --py sparkmagic && \
#     jupyter labextension disable ipyparallel-labextension
# RUN mkdir /home/$NB_USER/.sparkmagic
# COPY ./sparkmagic-config-$PROFILE.json /home/$NB_USER/.sparkmagic/config.json

# # Install prophet & dask
# # RUN conda install -c conda-forge fbprophet && \
# #     conda clean -a
# RUN mamba install --quiet --yes \
#     'fbprophet' \
#     && \
#     mamba clean --all -f -y && \
#     fix-permissions "${CONDA_DIR}" && \
#     fix-permissions "/home/${NB_USER}"

# Fix font
COPY ./simhei.ttf /opt/conda/lib/python3.8/site-packages/matplotlib/mpl-data/fonts/ttf/simhei.ttf

# R packages
RUN R -e "install.packages(c('igraph','languageserver'), dependencies=TRUE, repos='http://cran.rstudio.com/')"

# # Install dask
# RUN conda create --name dask --clone base && \
#     source activate dask
# RUN pip install --ignore-installed llvmlite \
#     nbconvert==5.6.1 \
#     dask==2021.9.1 \
#     distributed==2021.6.0 \
#     dask-gateway==0.9.0 \
#     dask-ml \
#     msgpack==1.0.2 \
#     && \
#     python -m ipykernel install --user --name dask --display-name "Dask"

RUN rm -rf ~/.cache/pip ~/.cache/yarn

# Dask Scheduler & Bokeh ports
EXPOSE 8787
EXPOSE 8786

USER $NB_UID
