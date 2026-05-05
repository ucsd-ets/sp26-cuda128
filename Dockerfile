# Base image for CDA

ARG BASE_CONTAINER=quay.io/jupyter/base-notebook:lab-4.5.6
FROM $BASE_CONTAINER

LABEL maintainer="UC San Diego ITS/ATS <datahub@ucsd.edu>"

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS="yes"
RUN apt-get update -y && \
    apt-get -qq install -y --no-install-recommends \
    git \
    libgdal-dev \
    libproj-dev \
    libgeos-dev \
    libudunits2-dev \
    libgit2-dev \
    pkg-config \
    curl \
    rsync \
    unzip \
    less \
    nano \
    vim \
    cmake \
    tmux \
    screen \
    gnupg \
    htop \
    wget \
    strace \
    openssh-client \
    openssh-server \
    netcat-openbsd \
    p7zip \
    apt-utils \
    jq \
    build-essential \
    p7zip-full && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    chmod g-s /usr/bin/screen && \
    chmod 1777 /var/run/screen

USER jovyan

# Install uv for faster package installations
RUN pip3 install --no-cache-dir --upgrade uv

RUN uv pip install --system jupyter-ai==3.0.0 mistral-vibe jupyter-ai-claude-code

ARG TORCH_VERSION=2.11.0
RUN uv pip install --system \
        --extra-index-url https://pypi.nvidia.com \
        --extra-index-url https://download.pytorch.org/whl/cu128 \
        nvidia-cuda-nvcc-cu12 \
        nvidia-nccl-cu12 \
        cuda-python \
        opencv-contrib-python-headless \
        opencv-python \
        PyQt5 \
        pycocotools \
        pillow \
        scapy \
        nvidia-cudnn-cu12 \
        torch==$TORCH_VERSION \
        torchvision \
        torchaudio \
        tensorrt \
        transformers \
        datasets \
        accelerate \
        huggingface-hub \
        timm \
    && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER && \
    uv cache clean

