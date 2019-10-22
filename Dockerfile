FROM ubuntu:18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

#
# Nvidia CUDA
#
# Based on:
#     https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/ubuntu18.04/10.1/base/Dockerfile
#     https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/ubuntu18.04/10.1/runtime/Dockerfile
#
# License: see LICENSE-Nvidia
#
RUN apt-get update && apt-get install -y --no-install-recommends \
gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl && \
    rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 10.1.243

ENV CUDA_PKG_VERSION 10-1=$CUDA_VERSION-1

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-$CUDA_PKG_VERSION \
    cuda-compat-10-1 && \
    ln -s cuda-10.1 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411"

# CUDA runttime
ENV NCCL_VERSION 2.4.8

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-libraries-$CUDA_PKG_VERSION \
    cuda-nvtx-$CUDA_PKG_VERSION \
    libnccl2=$NCCL_VERSION-1+cuda10.1 && \
    apt-mark hold libnccl2 && \
    rm -rf /var/lib/apt/lists/*


#
# Anaconda
#
# Based on:
#     https://github.com/ContinuumIO/docker-images/blob/master/anaconda3/debian/Dockerfile
#
# License: see LICENSE-Anaconda
#
ENV PATH="${PATH}:/opt/conda/bin/"

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git mercurial subversion && \
    apt-get clean

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy


#
# ML packages
#
RUN conda update -n base -c defaults conda

RUN conda install -y -c conda-forge plotly

RUN conda install -y -c conda-forge xgboost
RUN conda install -y -c conda-forge lightgbm
RUN conda install -y -c conda-forge catboost

RUN conda install -y -c conda-forge hyperopt

RUN conda install -y -c pytorch pytorch
RUN conda install -y -c pytorch torchvision

# RUN conda install -c conda-forge albumentations

RUN conda install -c anaconda pillow


#
# Misc
#
RUN apt-get update && apt-get install -y \
    unzip

RUN useradd --create-home --shell /bin/bash apollo

USER apollo
WORKDIR /home/apollo

EXPOSE 8888

