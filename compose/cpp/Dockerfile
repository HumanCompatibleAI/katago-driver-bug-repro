# To build, navigate to the *root* of this repo and run:
# docker build . -f compose/cpp/Dockerfile -t humancompatibleai/goattack:cpp
#
# Commands to build alternative targets:
# docker build . -f compose/cpp/Dockerfile -t humancompatibleai/goattack:cpp-build-deps --target build-*
#
# KataGo has been tested on CUDA 11.1 with CUDNN 8.0.4
# See https://github.com/lightvector/KataGo/blob/master/Compiling.md.
FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04 AS build-deps

ENV DEBIAN_FRONTEND=noninteractive

# Update NVidia signing key
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub

# Install apt packages
RUN apt-get update -q \
  && apt-get install -y \
  # Utilities
  curl \
  git \
  gpustat \
  sudo \
  tmux \
  unzip \
  vim \
  wget \
  # Packages needed to compile KataGo/cpp
  gcc \
  gdb \
  libgoogle-perftools-dev \
  libssl-dev \
  libzip-dev \
  zlib1g-dev \
  # Clean up
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install cmake
# Instructions from https://cliutils.gitlab.io/modern-cmake/chapters/intro/installing.html
RUN wget -qO- "https://cmake.org/files/v3.22/cmake-3.22.0-linux-x86_64.tar.gz" \
  | tar --strip-components=1 -xz -C /usr/local

# Copy over KataGo cpp files and compile.
# See https://github.com/lightvector/KataGo/blob/master/Compiling.md.

FROM build-deps as build-raw
COPY ./engines/KataGo/cpp /engines/KataGo/cpp
WORKDIR /engines/KataGo/cpp
RUN cmake . -DUSE_BACKEND=CUDA -DUSE_TCMALLOC=1 -DNO_GIT_REVISION=1
RUN make clean && make -j

# Actual production image, without development headers.
FROM nvidia/cuda:11.1.1-cudnn8-runtime-ubuntu20.04 AS prod

ENV DEBIAN_FRONTEND=noninteractive

# Update NVidia signing key
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub

# Install useful apt packages
RUN apt-get update -q \
  && apt-get install -y \
  # Utilities
  cron \
  curl \
  git \
  gpustat \
  htop \
  rsync \
  sudo \
  tmux \
  unzip \
  uuid-runtime \
  vim \
  wget \
  # KataGo runtime libraries
  libgoogle-perftools4 \
  libssl1.1 \
  libzip5 \
  zlib1g \
  # Clean up
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Copy over binaries
COPY --from=build-raw /engines/KataGo/cpp/katago /engines/KataGo/cpp/katago

# Copy over configs
COPY ./configs /configs

# Reset working directory
WORKDIR /
