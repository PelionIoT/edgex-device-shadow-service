#! /bin/sh

#
# Base compile options for mbed-edge
#
BASE_OPTIONS="-DDEVELOPER_MODE=ON -DFIRMWARE_UPDATE=OFF"

#
# DEBUG options: DEBUG, INFO, WARN, ERROR
#
DEBUG_OPTIONS="ERROR"

#
# Maximum # endpoints that can be registered
#
ENDPOINT_LIMIT=1000

#
# mbed-edge compile options
#
OPTIONS="${BASE_OPTIONS} -DTRACE_LEVEL=${DEBUG_OPTIONS} -DDEDGE_REGISTERED_ENDPOINT_LIMIT=${ENDPOINT_LIMIT}"

#
# rebuild vs. build
#
ARG="$1"

if [ "${ARG}" = "-r" ]; then
   if [ -d /home/arm/mbed-edge ]; then
	cd /home/arm/mbed-edge
        /bin/rm -f build > /dev/null 2>&1
        mkdir build
        cd /home/arm
   fi
fi

#
# Build mbed-edge
#
if [ -d /home/arm/mbed-edge ]; then
   if [ -d /home/arm/mbed-edge/build ]; then
      if [ -f /home/arm/mbed-edge/config/mbed_cloud_dev_credentials.c ]; then
           echo "Compiling mbed edge core..."
           cd /home/arm/mbed-edge
	   /bin/rm -rf build > /dev/null 2>&1
	   mkdir build
	   cd build
           echo cmake ${OPTIONS} ..
           cmake ${OPTIONS} ..
  	   make
      else
	   echo "Pelion API Key not configured. Mbed edge core not built."
      fi
   else
      echo "Mbed edge core not configured. Not built"
   fi 
else
    echo "Mbed edge core not cloned. Not built"
fi
