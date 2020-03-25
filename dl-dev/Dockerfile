FROM ubuntu:18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

#
# Nvidia CUDA
#
# Based on:
#     https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/ubuntu18.04/10.1/base/Dockerfile
#     https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/ubuntu18.04/10.1/runtime/Dockerfile
#     https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/ubuntu18.04/10.1/devel/Dockerfile
#     https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/ubuntu18.04/10.1/devel/cudnn7/Dockerfile
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
    libcublas10=10.2.1.243-1 \
    libnccl2=$NCCL_VERSION-1+cuda10.1 && \
    apt-mark hold libnccl2 && \
    rm -rf /var/lib/apt/lists/*

# CUDA development
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-nvml-dev-$CUDA_PKG_VERSION \
    cuda-command-line-tools-$CUDA_PKG_VERSION \
    cuda-libraries-dev-$CUDA_PKG_VERSION \
    cuda-minimal-build-$CUDA_PKG_VERSION \
    libnccl-dev=$NCCL_VERSION-1+cuda10.1 \
    libcublas-dev=10.2.1.243-1 \
    && \
    rm -rf /var/lib/apt/lists/*

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

# CUDNN
ENV CUDNN_VERSION 7.6.5.32
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn7=$CUDNN_VERSION-1+cuda10.1 \
    libcudnn7-dev=$CUDNN_VERSION-1+cuda10.1 \
    && \
    apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*


#
# TensorRT
#
ENV LIBNVINFER_VERSION 6.0.1-1+cuda10.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    libnvinfer6=$LIBNVINFER_VERSION \
    libnvonnxparsers6=$LIBNVINFER_VERSION \
    libnvparsers6=$LIBNVINFER_VERSION \
    libnvinfer-plugin6=$LIBNVINFER_VERSION \
    libnvinfer-dev=$LIBNVINFER_VERSION \
    libnvonnxparsers-dev=$LIBNVINFER_VERSION \
    libnvparsers-dev=$LIBNVINFER_VERSION \
    libnvinfer-plugin-dev=$LIBNVINFER_VERSION

RUN apt-get update && apt-get install -y python3-libnvinfer python3-libnvinfer-dev

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
# Build tools
#
RUN apt-get update && apt-get install -y build-essential manpages-dev


#
# Conda bases
#
RUN conda update -n base -c defaults conda


#
# CV packages
#
RUN conda install -y -c pytorch pytorch'>=1.4.0'
RUN conda install -y -c pytorch torchvision'>=0.5.0'

RUN pip install --upgrade tensorflow
# RUN conda install -y -c conda-forge tensorflow

# RUN conda install -c anaconda pillow
# RUN conda install -y -c conda-forge opencv

RUN conda uninstall -y --force pillow pil jpeg libtiff libjpeg-turbo
RUN pip uninstall -y pillow pil jpeg libtiff libjpeg-turbo
RUN conda install -y -c conda-forge libjpeg-turbo pillow==6.0.0
RUN CFLAGS="${CFLAGS} -mavx2" pip install --upgrade --no-cache-dir --force-reinstall --no-binary :all: --compile pillow-simd
RUN conda install -y -c zegami libtiff-libjpeg-turbo
RUN conda install -y jpeg libtiff

RUN pip install --upgrade opencv-python
RUN conda install -c conda-forge imgaug
RUN conda install -c conda-forge albumentations
RUN apt-get update && apt-get install -y libgl1

RUN pip install --upgrade pytorch-lightning


#
# ML packages
#
RUN conda install -y -c conda-forge numpy
RUN conda install -y -c conda-forge scikit-learn
RUN conda install -y -c conda-forge matplotlib'>=3.1.2'
RUN conda install -y -c anaconda seaborn

RUN conda install -y -c conda-forge xgboost
RUN conda install -y -c conda-forge lightgbm
RUN conda install -y -c conda-forge catboost

RUN pip install --upgrade 'hyperopt>=0.2.3'

RUN pip install --upgrade ray
RUN pip install --upgrade 'ray[tune]'


#
# NLP packages
#
RUN conda install -y -c anaconda gensim
RUN conda install -y -c anaconda nltk


#
# Visualization
#
RUN conda install -y -c bokeh bokeh
RUN conda install -y -c conda-forge plotly


#
# Data processing
#
RUN conda install -y -c anaconda hdf5
RUN conda install -y -c conda-forge python-lmdb
RUN conda install -y -c anaconda psycopg2


#
# Tools
#
RUN conda install -y -c conda-forge jupyter_contrib_nbextensions
RUN conda install -y -c conda-forge pyyaml
RUN conda install -y -c conda-forge tabulate
RUN conda install -y -c anaconda click


#
# Network visualization
#
RUN conda install -y -c anaconda graphviz
RUN conda install -y -c conda-forge python-graphviz
RUN conda install -y -c conda-forge pydot
RUN pip install --upgrade torchviz
RUN pip install --upgrade hiddenlayer
RUN pip install --upgrade torchsummary


#
# Linux utils
#
RUN apt-get update && apt-get install -y vim mc
RUN apt-get update && apt-get install -y psmisc strace ltrace lsof gdb


#
# Python debug
#
# RUN apt-get update && apt-get install -y python3.7-dbg libpython3.7-dbg
RUN pip install --upgrade pyrasite
RUN pip install --upgrade pystack
RUN pip install --upgrade py-spy
RUN pip install --upgrade yappi


#
# Misc
#
RUN apt-get update && apt-get install -y unzip zsh

RUN useradd --create-home --shell /bin/bash apollo

USER apollo
WORKDIR /home/apollo

RUN wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | zsh || true
ENV ZSH_THEME robbyrussell
ENV TERM xterm

