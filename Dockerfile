FROM continuumio/anaconda3:2019.07

ENV PATH="${PATH}:/opt/conda/bin/"

RUN useradd --create-home --shell /bin/bash apollo

RUN pip install xgboost

USER apollo
WORKDIR /home/apollo

EXPOSE 8888
