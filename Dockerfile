FROM nvidia/cuda:11.6.2-devel-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    git \
    cmake \
    build-essential \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libboost-test-dev \
    libeigen3-dev \
    libsuitesparse-dev \
    libfreeimage-dev \
    libmetis-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev

# Change dir, put all sources & binaries under /opt
WORKDIR /opt

# Install Ceres Solver
# PyCeres requires ceres >= 2.1
ARG CERES_SOLVER_VERSION=2.1.0
RUN apt-get install -y libatlas-base-dev libsuitesparse-dev && \
    git clone https://ceres-solver.googlesource.com/ceres-solver && \
    cd ceres-solver && \
    git checkout ${CERES_SOLVER_VERSION} && \
    mkdir build && \
    cd build && \
    cmake .. -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF && \
    make -j && \
    make install

# Install Colmap
ARG COLMAP_COMMIT=1f31e94
RUN git clone https://github.com/colmap/colmap.git && \
    cd colmap && \
    git checkout ${COLMAP_COMMIT} && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_CUDA_ARCHITECTURES=all-major && \
    make -j && \
    make install

# Install PyTorch for HLOC & Pixel Perfect SfM
ARG PYTORCH_VERSION=1.13.1
ARG TORCHVISION_VERSION=0.14.1
RUN apt-get install -y python3 python3-pip && \
    pip3 install torch==${PYTORCH_VERSION}+cu116 torchvision==${TORCHVISION_VERSION}+cu116 --extra-index-url https://download.pytorch.org/whl/cu116

# Install pycolmap ahead
ARG PYCOLMAP_COMMIT=391a1c2
RUN git clone --recursive https://github.com/colmap/pycolmap/ && \
    cd pycolmap && \
    git checkout ${PYCOLMAP_COMMIT} && \
    pip3 install -e .

# Install HLOC
# keep source code editable for convenience
RUN git clone --recursive https://github.com/cvg/Hierarchical-Localization/ hloc && \
    cd hloc && \
    pip3 install -e .

# Install Pixel Perfect SfM
RUN apt-get install -y libhdf5-dev && \
    git clone https://github.com/cvg/pixel-perfect-sfm --recursive && \
    cd pixel-perfect-sfm && \
    sed -i 's/git+https:\/\/github.com\/colmap\/pycolmap/pycolmap>=0.4.0/g' requirements.txt && \
    pip3 install -r requirements.txt && \
    pip3 install -e .

RUN mkdir /workspace
WORKDIR /workspace
