FROM ubuntu:16.04

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apt update &&                  \
    apt upgrade -y &&              \
    apt dist-upgrade -y &&         \
    apt install -y                 \
        git                        \
        cmake			   \
        wget                       \
        xvfb                       \
        flex                       \
        dh-make                    \
        debhelper                  \
        checkinstall               \
        fuse                       \
        snapcraft                  \
        bison                      \
        libxcursor-dev             \
        libxcomposite-dev          \
        software-properties-common \
        build-essential            \
        libssl-dev                 \
        libxcb1-dev                \
        libx11-dev                 \
        libgl1-mesa-dev            \
        libudev-dev                \
        qt5-default                \
        qttools5-dev               \
        qtdeclarative5-dev         \
        qtpositioning5-dev         \
        qtbase5-dev                \
        libeigen3-dev		   \
        libqt5x11extras5-dev       \
	libflann-dev		   \
        libxt-dev		   \
	libboost1.58-all-dev
#RUN brew install vtk5 --with-qt

RUN wget https://www.vtk.org/files/release/8.2/VTK-8.2.0.tar.gz
#RUN wget https://www.vtk.org/files/release/8.1/VTKData-8.1.0.tar.gz

RUN tar -xzvf VTK-8.2.0.tar.gz
#RUN tar -xzvf VTKData-8.1.0.tar.gz
WORKDIR VTK-8.2.0
RUN mkdir build
WORKDIR build
RUN cmake -DVTK_Group_Qt=ON -DVTK_QT_VERSION=5 -DBUILD_SHARED_LIBS=ON ..
RUN make -j8
RUN make install -j8
WORKDIR ../..

RUN git clone https://github.com/PointCloudLibrary/pcl
RUN mkdir pcl/build
WORKDIR pcl
RUN git checkout pcl-1.9.1
WORKDIR build
RUN sed -i 's/cmake_minimum_required(VERSION 3.5 FATAL_ERROR)/cmake_minimum_required(VERSION 3.5 FATAL_ERROR)\nset (CMAKE_CXX_STANDARD 11)/g' ../CMakeLists.txt
RUN cmake ..
RUN make
RUN make install
WORKDIR ../..


RUN git clone https://github.com/maraatech/point-cloud-annotation-tool
#COPY point-cloud-annotation-tool /point-cloud-annotation-tool
WORKDIR point-cloud-annotation-tool
RUN mkdir build
WORKDIR build
RUN cmake ..
RUN make
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/nvidia-418/bin
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib/nvidia-418:/usr/lib32/nvidia-418
COPY complete_pc.ply /point-cloud-annotation-tool/complete_pc.ply
