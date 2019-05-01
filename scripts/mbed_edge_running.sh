#!/bin/sh

PID="`ps -ef | grep edge-core | grep -v pic | grep -v MBED | grep -v grep | awk '{print $2}'`"
if [ "${PID}X" = "X" ]; then
    echo "NO"
else
    echo "YES"
fi

