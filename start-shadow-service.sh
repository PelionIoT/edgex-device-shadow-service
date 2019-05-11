#!/bin/sh

IP="0.0.0.0"

set -x

docker run -d -p ${IP}:17362:17362 -p ${IP}:8235:8234 -p ${IP}:28175:28175 -p ${IP}:3333:22 -p ${IP}:2883:1883 -t mbed/edgex-device-shadow-service  /home/arm/start_instance.sh $*
