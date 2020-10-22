FROM ros:melodic-perception

RUN apt-get update && apt-get install -y wget gnupg

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key| apt-key add -
RUN echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-10 main" > /etc/apt/sources.list.d/llvm10.list

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE
RUN echo "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo bionic main" > /etc/apt/sources.list.d/realsense.list

RUN apt-get update && \
      DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
      cmake \
      libtbb-dev \
      libeigen3-dev \
      libglew-dev \
      ccache \
      libjpeg-dev \
      libpng-dev \
      openssh-client \
      liblz4-dev \
      libbz2-dev \
      libboost-regex-dev \
      libboost-filesystem-dev \
      libboost-date-time-dev \
      libboost-program-options-dev \
      libopencv-dev \
      libpython2.7-dev \
      libgtest-dev \
      lsb-core \
      gcovr \
      ggcov \
      lcov \
      librealsense2-dev \
      librealsense2-gl-dev \
      librealsense2-dkms \
      librealsense2-utils \
      doxygen \
      graphviz \
      libsuitesparse-dev \
      clang-10 \
      clang-format-10 \
      build-essential \
      python-catkin-tools && \
      rm -rf /var/lib/apt/lists/*

# if you want to reference a previously defined env variable in another definition, use multiple ENV
ENV CATKIN_WS=/root/catkin_ws BASALT_ROOT=/root/catkin_ws/src/basalt_ros BASALT_ROS1_ROOT=/root/catkin_ws/src/basalt_ros/basalt_ros1

COPY ./ $BASALT_ROOT
WORKDIR $CATKIN_WS

RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; catkin config -DCMAKE_BUILD_TYPE=Release && catkin build' && \
    sed -i '/exec "$@"/i \
               source "/root/catkin_ws/devel/setup.bash"' /ros_entrypoint.sh