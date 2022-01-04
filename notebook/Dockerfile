FROM jupyter/all-spark-notebook:2021-11-10

MAINTAINER xiaomao23zhi <https://github.com/xiaomao23zhi/>

# Env
ENV LIVY_SERVER="http://172.31.201.47:8998"

USER root

# Install packages
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    graphviz \
    julia \
    language-pack-zh-hans && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
 
# Fix font
COPY ./simhei.ttf /opt/conda/lib/python3.8/site-packages/matplotlib/mpl-data/fonts/ttf/simhei.ttf

# Before notebook script for sparkmagic
COPY ./sparkmagic.sh /usr/local/bin/before-notebook.d/sparkmagic.sh
RUN chmod +x /usr/local/bin/before-notebook.d/sparkmagic.sh
    
# # Install Julia
# ARG julia_version="1.6.4"
# ENV JULIA_DEPOT_PATH=/opt/julia \
#     JULIA_PKGDIR=/opt/julia \
#     JULIA_VERSION="${julia_version}"

# WORKDIR /tmp

# # hadolint ignore=SC2046
# RUN set -x && \
#     julia_arch=$(uname -m) && \
#     julia_short_arch="${julia_arch}" && \
#     if [ "${julia_short_arch}" == "x86_64" ]; then \
#       julia_short_arch="x64"; \
#     fi; \
#     julia_installer="julia-${JULIA_VERSION}-linux-${julia_arch}.tar.gz" && \
#     julia_major_minor=$(echo "${JULIA_VERSION}" | cut -d. -f 1,2) && \
#     mkdir "/opt/julia-${JULIA_VERSION}" && \
#     wget -q "https://julialang-s3.julialang.org/bin/linux/${julia_short_arch}/${julia_major_minor}/${julia_installer}" && \
#     tar xzf "${julia_installer}" -C "/opt/julia-${JULIA_VERSION}" --strip-components=1 && \
#     rm "${julia_installer}" && \
#     ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia
# 
# # Show Julia where conda libraries are \
# RUN mkdir /etc/julia && \
#     echo "push!(Libdl.DL_LOAD_PATH, \"${CONDA_DIR}/lib\")" >> /etc/julia/juliarc.jl && \
#     # Create JULIA_PKGDIR \
#     mkdir "${JULIA_PKGDIR}" && \
#     chown "${NB_USER}" "${JULIA_PKGDIR}" && \
#     fix-permissions "${JULIA_PKGDIR}"

USER ${NB_USER}

# Install from requirements.txt file
COPY --chown=${NB_UID}:${NB_GID} requirements.txt /tmp/
RUN pip install --no-cache-dir --requirement /tmp/requirements.txt && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
    
# Add user-settings
COPY --chown=${NB_UID}:${NB_GID} user-settings/ /home/jovyan/.jupyter/lab/user-settings/

# # Install prophet
# # RUN conda install -c conda-forge fbprophet && \
# #     conda clean -a
# RUN mamba install --quiet --yes \
#     'fbprophet' \
#     && \
#     mamba clean --all -f -y && \
#     fix-permissions "${CONDA_DIR}" && \
#     fix-permissions "/home/${NB_USER}"

# # Install elyra
# RUN pip install --upgrade elyra-pipeline-editor-extension && \
#     jupyter lab build

# R packages
RUN R -e "install.packages(c('igraph','languageserver'), dependencies=TRUE, repos='http://cran.rstudio.com/')"

# iJulia packages
RUN julia -e 'import Pkg; Pkg.update()' && \
    julia -e 'import Pkg; Pkg.add("HDF5")' && \
    julia -e 'using Pkg; Pkg.add.(["IJulia", "LanguageServer"]); pkg"precompile"' && \
    # move kernelspec out of home \
    mv "${HOME}/.local/share/jupyter/kernels/julia"* "${CONDA_DIR}/share/jupyter/kernels/" && \
    chmod -R go+rx "${CONDA_DIR}/share/jupyter" && \
    rm -rf "${HOME}/.local" && \
    fix-permissions "${CONDA_DIR}/share/jupyter"

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

# Install sparkmagic
RUN jupyter-kernelspec install --user $(pip show sparkmagic | grep Location | cut -d" " -f2)/sparkmagic/kernels/sparkkernel && \
    jupyter-kernelspec install --user $(pip show sparkmagic | grep Location | cut -d" " -f2)/sparkmagic/kernels/pysparkkernel && \
    jupyter serverextension enable --py sparkmagic && \
    jupyter labextension disable ipyparallel-labextension
RUN mkdir /home/$NB_USER/.sparkmagic
COPY ./config.json.template /home/$NB_USER/.sparkmagic/config.json.template

# clean up
RUN rm -rf ~/.cache/pip ~/.cache/yarn

# Dask Scheduler & Bokeh ports
EXPOSE 8787
EXPOSE 8786


WORKDIR "${HOME}"

USER $NB_UID
