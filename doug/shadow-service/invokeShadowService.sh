#!/bin/sh

rm -f ./logs/*.log 2> /dev/null
mkdir -p ./logs
cd /home/arm/shadow-service
java -Dmax-thread-pool-size=30 -Dconfig_file="conf/service.properties" -jar mbed-edgex-shadow-service-1.0.war 2>&1 1>./logs/shadow-service.log
