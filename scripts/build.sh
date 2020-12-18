#!/bin/bash
source /opt/ros/melodic/setup.bash
catkin config -DCMAKE_BUILD_TYPE=Release -DSAVE_TIMES=ON
catkin build
