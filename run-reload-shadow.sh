#!/bin/sh

echo "Getting device shadow service container ID..."

ID=`docker ps | grep edgex-device-shadow-service | awk '{print $1}'`

if [ "${ID}X" != "X" ]; then
    echo "Stopping $ID"
    docker stop ${ID}
else
    echo "No running shadow service container found... OK"
fi

if [ "${ID}X" != "X" ]; then
    echo "Removing $ID"
    docker rm --force ${ID}
fi

echo "Looking for existing container image..."

ID=`docker images | grep edgex-device-shadow-service | awk '{print $3}'`
if [ "${ID}X" != "X" ]; then
    echo "Removing Image $ID"
    docker rmi --force ${ID}
else
    echo "No container image found... (OK)"
fi

echo "Building container image..."

if [ -f Dockerfile ]; then
    docker build -t "mbed/edgex-device-shadow-service" .
else
    echo "Unable to find Dockerfile... change to repo directory and retry..."
    exit 1
fi

if [ "$?" = "0" ]; then
    echo "Starting Device Shadow Service..."
    ./start-shadow-service.sh $*
    if [ "$?" = "0" ]; then
        echo "Device Shadow Service Started!"
        exit 0
    else
 	echo "Device Shadow Service Start FAILED"
	exit 2
    fi
fi
