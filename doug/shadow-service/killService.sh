#!/bin/sh

PID=`ps -ef | grep java | grep -v grep | grep shadow-service | awk '{ print $2 }'`

if [ "${PID}X" != "X" ]; then
     echo "Killing Shadow Service..."
     kill -9 ${PID}
else
     echo "Shadow Service is not running (OK)"
fi
exit 0
