FROM continuumio/anaconda3:2019.07

ENV PATH="${PATH}:/opt/conda/bin/"

RUN useradd --create-home --shell /bin/bash apollo

RUN conda update -n base -c defaults cond

RUN conda install -y -c conda-forge xgboost
RUN conda install -y -c conda-forge hyperopt

USER apollo
WORKDIR /home/apollo

EXPOSE 8888
