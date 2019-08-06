FROM continuumio/anaconda3:2019.07

RUN useradd --create-home --shell /bin/bash apollo

USER apollo
WORKDIR /home/apollo

EXPOSE 8888
