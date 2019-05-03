#!/bin/sh

#
# must match port number used in WS URI within PelionEdgeCoreClientAPI (default is 4455)
#
SOCAT_PORT=4455

#
# must match socket file used by edge-core (default is /tmp/edge.sock) and in WS URI within PelionEdgeCoreClientAPI
#
SOCAT_SOCK=/tmp/edge.sock

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
        sleep 5
        socat TCP-LISTEN:${SOCAT_PORT},reuseaddr UNIX-CLIENT:${SOCAT_SOCK} &
    else 
        echo "Mbed edge core already running (OK)."
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
        socat TCP-LISTEN:${SOCAT_PORT},reuseaddr UNIX-CLIENT:${SOCAT_SOCK} &
    else
       echo "ERROR: Unable to build and launch mbed edge core."
       exit 1
    fi
fi
