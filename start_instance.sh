#!/bin/bash

update_hosts()
{
    sudo /home/arm/update_hosts.sh
}

run_shadow_service()
{
   cd /home/arm
   su -l arm -s /bin/bash -c "/home/arm/shadow-service/start.sh &"
}

run_configurator()
{
  cd /home/arm/configurator
  su -l arm -s /bin/bash -c "/home/arm/configurator/runConfigurator.sh 2>&1 1> /tmp/configurator.log &"
}

run_supervisord()
{
   /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf 2>&1 1>/tmp/supervisord.log
}

run_mosquitto() {
  cd /home/arm
  mosquitto -d -c /etc/mosquitto/mosquitto.conf &
}

set_perms() {
  cd /home/arm
  chown -R arm.arm .
}

run_nodered() {
  cd /home/arm
  su -l arm -s /bin/bash -c "node-red flows_81f2e72d62ee.json 2>&1 1>/tmp/node-red.log &"
  # su -l arm -s /bin/bash -c "node-red 2>&1 1>/tmp/node-red.log &"
}

main() 
{
   set_perms $*
   run_mosquitto
   run_configurator
   run_shadow_service
   # run_nodered
   run_supervisord
}

main $*
