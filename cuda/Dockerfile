FROM nvidia/cuda:11.1-cudnn8-devel-ubuntu18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

#
# Core
#
RUN apt-get update && apt-get install -y build-essential manpages-dev
RUN apt-get update && apt-get install -y wget curl net-tools
RUN apt-get update && apt-get install -y git mercurial subversion
RUN apt-get update && apt-get install -y unzip bzip2 gzip
RUN apt-get update && apt-get install -y psmisc strace ltrace lsof gdb htop
RUN apt-get update && apt-get install -y vim


#
# Anaconda
#
# Based on:
#     https://github.com/ContinuumIO/docker-images/blob/master/anaconda3/debian/Dockerfile
#
# License: see LICENSE-Anaconda
#
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git mercurial subversion && \
    apt-get clean

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy


#
# Conda base
#
RUN conda update -n base -c defaults conda


#
# Shell
#
RUN apt-get update && apt-get install -y zsh mc
RUN useradd --create-home --shell /bin/bash apollo

USER apollo
WORKDIR /home/apollo

RUN wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | zsh || true
ENV ZSH_THEME robbyrussell
ENV TERM xterm

USER root
WORKDIR /
