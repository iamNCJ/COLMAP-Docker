FROM nvidia/cuda:11.3.1-devel-ubuntu20.04

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
RUN apt-get install -y libatlas-base-dev libsuitesparse-dev && \
    git clone https://ceres-solver.googlesource.com/ceres-solver && \
    cd ceres-solver && \
    git checkout 2.1.0 && \
    mkdir build && \
    cd build && \
    cmake .. -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF && \
    make -j && \
    make install

# Install Colmap
# PATCH: add -fPIC when building colmap cuda library to link with pycolmap
RUN git clone https://github.com/colmap/colmap.git && \
    cd colmap && \
    git checkout dev && \
    sed -i 's/add_definitions("-DCUDA_ENABLED")/add_definitions("-DCUDA_ENABLED")\n\n        # add -fPIC when building colmap cuda library to link with pycolmap\n        set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -shared -Xcompiler -fPIC")/g' CMakeLists.txt && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j && \
    make install

# Install PyTorch for HLOC & Pixel Perfect SfM
RUN apt-get install -y python3 python3-pip && \
    pip3 install torch torchvision --extra-index-url https://download.pytorch.org/whl/cu113

# Install HLOC
RUN git clone --recursive https://github.com/cvg/Hierarchical-Localization/ hloc && \
    cd hloc/ && \
    pip3 install -e .

# Install Pixel Perfect SfM
RUN apt-get install -y libhdf5-dev && \
    git clone https://github.com/cvg/pixel-perfect-sfm --recursive && \
    cd pixel-perfect-sfm && \
    pip3 install -r requirements.txt && \
    pip3 install -e .

RUN mkdir /workspace
WORKDIR /workspace
