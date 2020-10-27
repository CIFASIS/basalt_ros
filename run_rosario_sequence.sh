#!/bin/bash
#
# Run rosbag play, visualization and save trajectory in a text file.
# It requires a catkin workspace containing pose_listener.

set -eE # Any subsequent commands which fail will cause the shell script to exit immediately
OUTPUT_TOPIC="/vio_back_end/odom"
CATKIN_WS_DIR=$HOME/catkin_ws/
BAG=$1

function cleanup() {
  printf "\e[31m%s %s\e[m\n" "Cleaning"
  if [ -n "${CID}" ] ; then
    docker container stop $CID
  fi
  # rosnode kill -a
}

trap cleanup INT
trap cleanup ERR

function wait_docker() {
    TOPIC=$1
    output=$(rostopic list $TOPIC 2> /dev/null || :) # force the command to exit successfully (i.e. $? == 0)
    echo $output
    while [ "$output" != $TOPIC ]; do # TODO max attempts
        sleep 1
        output=$(rostopic list $TOPIC 2> /dev/null || :)
    done
}

echo "Starting docker container (detached mode)"
CID=$(./run_basalt.sh -v detached)

wait_docker $OUTPUT_TOPIC

source ${CATKIN_WS_DIR}/devel/setup.bash
ROS_HOME=`pwd` roslaunch launch/play_bag_viz.launch \
    config_rviz:=$(pwd)/rviz/rviz_config.rviz \
    type:=O \
    topic:=$OUTPUT_TOPIC \
    save_to_file:=true \
    bagfile:=$BAG

#docker container logs $CID > logs_$CID.txt
cleanup
echo "END"