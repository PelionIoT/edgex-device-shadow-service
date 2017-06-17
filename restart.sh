#!/bin/sh

cd shadow-service
./killShadowService.sh
./runShadowService.sh
cd ${HOME}
