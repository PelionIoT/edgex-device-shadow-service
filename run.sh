#!/bin/sh

cd mds
./restart.sh
cd ${HOME}
cd configurator
cd conf
rm gateway.properties
ln -s ../../mds/container-bridge/conf/gateway.properties .
cd ..
./runConfigurator.sh 2>&1 1>configurator.log &
cd ${HOME}
