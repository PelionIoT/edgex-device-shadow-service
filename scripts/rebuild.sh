#!/bin/sh

API_KEY="`grep api_key= /home/arm/service/conf/service.properties | grep -v Pelion_API | cut -d'=' -f 2`"

LOG=/home/arm/mbed_edge_build.log

cd /home/arm/scripts

if [ ! -f ${HOME}/mbed_edge_core_building ]; then 
    touch ${HOME}/mbed_edge_core_building
    if [ "${API_KEY}X" != "X" ]; then
        if [ -f /home/arm/mbed-edge/config/mbed_cloud_dev_credentials.c ]; then
            echo "Mbed edge core already provisioned. Compiling..."
  	    rm ${LOG} > /dev/null 2>&1
            ./compile_mbed_edge_core.sh > ${LOG} 2>&1
        else
            echo "Provisioning mbed edge core..."
            ./get_dev_prov_file.sh ${API_KEY}  | sed 's/\\n"//g' | sed 's/"*\\n//g' | sed 's/"\//\//g' | sed 's/\\//g' | sed s/'>'/'>'\\n/g | sed s/';'/';'\\n/g | sed s/'#'/\\n'#'/g | sed s/"\\n"/\\n/g > /home/arm/mbed-edge/config/mbed_cloud_dev_credentials.c
            echo "Mbed edge core provisioned. Compiling..."
  	    rm ${LOG} > /dev/null 2>&1
            ./compile_mbed_edge_core.sh > ${LOG} 2>&1
        fi
    else
        echo "Pelion API Key not set. Please set the API Key, then re-run $0"
        exit 1
    fi
    rm ${HOME}/mbed_edge_core_building > /dev/null 2>&1
else
    echo "Mbed Edge Core already building..."
    exit 0
fi
