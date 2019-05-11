#!/bin/sh

#
# must match port number used in WS URI within PelionEdgeCoreClientAPI (default is 4455)
#
SOCAT_PORT_PT=4455
SOCAT_PORT_MGMT=4456

#
# must match socket file used by edge-core (default is /tmp/edge.sock) and in WS URI within PelionEdgeCoreClientAPI
#
SOCAT_SOCK=/tmp/edge.sock

#
# socat options
SOCAT_OPTIONS_PT="TCP-LISTEN:${SOCAT_PORT_PT},reuseaddr UNIX-CLIENT:${SOCAT_SOCK}"
SOCAT_OPTIONS_MGMT="TCP-LISTEN:${SOCAT_PORT_MGMT},reuseaddr UNIX-CLIENT:${SOCAT_SOCK}"

#
# socat PID
#
PID_SOCAT="`ps -ef | grep socat | grep -v grep | awk '{print $2}'`"

#
# Pelion API Key
#
API_KEY="`grep api_key= /home/arm/service/conf/service.properties | grep -v Pelion_API | cut -d'=' -f 2`"
if [ "${API_KEY}X" = "X" ]; then
    echo "Unable to start mbed edge core - Pelion API Key has not been set yet."
    exit 0
fi

if [ -x /home/arm/mbed-edge/build/bin/edge-core ]; then
    RUNNING="`./mbed_edge_running.sh`"
    if [ "${RUNNING}X" = "NOX" ]; then
        echo "Starting mbed edge core..."
        cd /home/arm/mbed-edge/build/bin
	rm -f /home/arm/edge.log > /dev/null 2>&1
        ./edge-core > /home/arm/edge.log 2>&1 &
	echo "Waiting while mbed edge core starts up...."
        sleep 15 
	echo "Starting socat links..."
	if [ "${PID_SOCAT}X" != "X" ]; then
            kill ${PID_SOCAT} > /dev/null 2>&1
            sleep 5
        fi
	socat ${SOCAT_OPTIONS_PT} > /dev/null 2>&1 &
	socat ${SOCAT_OPTIONS_MGMT} > /dev/null 2>&1 &
    else 
        echo "Mbed edge core already running (OK)."
 	if [ "${PID_SOCAT}X" != "X" ]; then
            kill ${PID_SOCAT} > /dev/null 2>&1
	    sleep 5
	fi
	socat ${SOCAT_OPTIONS_PT} > /dev/null 2>&1 &
	socat ${SOCAT_OPTIONS_MGMT} > /dev/null 2>&1 &
        exit 0
    fi
else
    echo "Mbed edge core not built. Building..."
    cd /home/arm/scripts
    ./rebuild.sh
    if [ -x /home/arm/mbed-edge/build/bin/edge-core ]; then
        echo "Starting mbed edge core..."
        cd /home/arm/mbed-edge/build/bin
	rm -f /home/arm/edge.log > /dev/null 2>&1
        ./edge-core > /home/arm/edge.log 2>&1 &
	sleep 5
	if [ "${PID_SOCAT}X" != "X" ]; then
            kill ${PID_SOCAT} > /dev/null 2>&1
            sleep 5
        fi
	socat ${SOCAT_OPTIONS_PT} > /dev/null 2>&1 &
	socat ${SOCAT_OPTIONS_MGMT} > /dev/null 2>&1 &
    else
       echo "ERROR: Unable to build and launch mbed edge core."
       if [ "${PID_SOCAT}X" != "X" ]; then
            kill ${PID_SOCAT} > /dev/null 2>&1
            sleep 5
       fi
       exit 1
    fi
fi
