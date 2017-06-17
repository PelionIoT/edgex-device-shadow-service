#!/bin/sh

cd mds
./restart.sh
cd ${HOME}
cd configurator
cd conf
rm shadow-service.properties
ln -s ${HOME}/shadow-service/conf/shadow-service.properties .
cd ..
./runConfigurator.sh 2>&1 1>configurator.log &
cd ${HOME}
