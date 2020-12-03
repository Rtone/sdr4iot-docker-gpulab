# Start from a core gpu-enabled stack version
FROM gitlab.ilabt.imec.be:4567/ilabt/gpu-docker-stacks/tensorflow-notebook:cuda10.1-ubuntu18.04
# Set user as root so next commands run correctly
USER root
# Install dependencies
RUN apt-get update && apt install -y graphviz libgraphviz-dev libcgraph6 && rm -rf /var/lib/apt/lists/*
# Install tensorflow 2.3, kerastuner and plotly
RUN "${CONDA_DIR}/bin/pip" install --upgrade tensorflow==2.3 keras-tuner plotly

# Add Jupyter/JupyterLab Server Proxy support, prerequisite for
# forwarding /code-server to the port on which code-server will run

RUN     conda install -c conda-forge --freeze-installed \
              jupyter-server-proxy cppcheck && \
        "${CONDA_DIR}/bin/pip" install -vvv git+git://github.com/jupyterhub/jupyter-server-proxy@v1.5.0 && \
        jupyter serverextension enable --py --sys-prefix jupyter_server_proxy && \
        jupyter labextension install --no-build @jupyterlab/server-proxy && \
        conda clean -afy && \
        jupyter lab build -y && \
        jupyter lab clean -y && \
        npm cache clean --force && \
        fix-permissions "${CONDA_DIR}" && \
        fix-permissions "/home/${NB_USER}"

WORKDIR $HOME
USER    $NB_UID
