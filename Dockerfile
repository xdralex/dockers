FROM continuumio/anaconda3:2019.07

RUN useradd --create-home --shell /bin/bash apollo
RUN echo "\nPATH=$PATH:/opt/conda/bin/\n" >> /home/apollo/.profile

USER apollo
WORKDIR /home/apollo

EXPOSE 8888
