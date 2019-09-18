FROM continuumio/anaconda3:2019.07

ENV PATH="${PATH}:/opt/conda/bin/"

RUN useradd --create-home --shell /bin/bash apollo

RUN conda update -n base -c defaults conda

RUN conda install -y -c conda-forge xgboost
RUN conda install -y -c conda-forge lightgbm
RUN conda install -y -c conda-forge catboost
RUN conda install -y -c conda-forge hyperopt
RUN conda install -y -c conda-forge plotly

USER apollo
WORKDIR /home/apollo

EXPOSE 8888
