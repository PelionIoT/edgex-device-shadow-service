#!/bin/sh

#
# Default routing IP for port mapping
#
IP="0.0.0.0"

#
# Find our primary host IP address
#
HOST="`uname -s`"
INTERFACE="eth0"

if [ "${HOST}" = "Linux" ]; then
     INTERFACE="`route | grep default | awk '{print $8}'`"
fi
if [ "${HOST}" = "Darwin" ]; then
     INTERFACE="`route get 8.8.8.8 | grep interface | awk '{print $2}'`"
fi
HOST_IP_ADDRESS="`ifconfig ${INTERFACE} | grep inet | grep -v inet6 | awk '{print $2}'`"

#
# Run the docker instance
#
set -x
docker run -d -p ${IP}:17362:17362 -p ${IP}:8235:8234 -p ${IP}:28175:28175 -p ${IP}:3333:22 -p ${IP}:2883:1883 -e DOCKER_HOST=${HOST_IP_ADDRESS} -t mbed/edgex-device-shadow-service  /home/arm/start_instance.sh $*
