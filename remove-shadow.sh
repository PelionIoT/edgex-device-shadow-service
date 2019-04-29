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
