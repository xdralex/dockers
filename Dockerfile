FROM continuumio/anaconda3:2019.07

RUN useradd --create-home --shell /bin/bash apollo

RUN pip install xgboost

USER apollo
WORKDIR /home/apollo

ENV PATH="${PATH}:/opt/conda/bin/"

EXPOSE 8888
