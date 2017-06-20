#!/bin/sh

cd shadow-service
./killService.sh
./runService.sh
cd ${HOME}
