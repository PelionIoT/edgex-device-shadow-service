#!/bin/sh

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
    else
       echo "ERROR: Unable to build and launch mbed edge core."
       exit 1
    fi
fi
