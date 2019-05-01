#!/bin/sh

cd ${HOME}/shadow-service
./killService.sh
./runService.sh &
cd ${HOME}/scripts
./restart_mbed_edge_core.sh &
cd ${HOME}
