#!/bin/bash

run_supervisord()
{
   /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf 2>&1 1>/tmp/supervisord.log
}

run_shadow_service()
{
   cd /home/arm
   su -l arm -s /bin/bash -c "/home/arm/restart.sh &"
}

run_properties_editor()
{
  cd /home/arm/properties-editor
  su -l arm -s /bin/bash -c "/home/arm/properties-editor/runPropertiesEditor.sh 2>&1 1> /tmp/properties-editor.log &"
}

run_mosquitto() {
  cd /home/arm
  mosquitto -d -c /etc/mosquitto/mosquitto.conf &
}

run_mbed_edge_core() {
   if [ -d /home/arm/mbed-edge/build/bin ]; then 
       cd /home/arm/mbed-edge/build/bin
       if [ -x ./edge-core ]; then 
           echo "Starting mbed edge core..."
           ./edge-core &
       else
   	   echo "Mbed edge core not executable. Ignoring run request."
       fi
   else
       echo "Mbed edge core not built. Ignoring run request."
   fi
}

set_perms() {
  cd /home/arm
  chown -R arm.arm .
}

validate_edgex_ip_address() {
  if [ "${DOCKER_HOST}X" != "X" ]; then
     echo "EdgeX IP Address already set to: ${DOCKER_HOST}... OK"
  else
     export DOCKER_HOST="`ip route show default | awk '/default/ {print $3}'`"
     echo "Setting EdgeX IP Address to: ${DOCKER_HOST}..."
  fi
}

set_edgex_ip_address() {
  if [ "${DOCKER_HOST}X" != "X" ]; then
      echo "Setting EdgeX IP Address to: ${DOCKER_HOST}..."
      cd /home/arm/service/conf
      mv service.properties service.properties.EdgeX
      sed "s/EdgeX_IP_Address_Goes_Here/${DOCKER_HOST}/g" < service.properties.EdgeX > service.properties
      chown arm.arm service.properties
      chmod 600 service.properties
  else 
      echo "Not setting EdgeX IP Address (not set)...OK..."
  fi
}

main() 
{
   set_perms $*
   validate_edgex_ip_address $*
   set_edgex_ip_address $*
   run_mosquitto
   run_mbed_edge_core
   run_properties_editor
   run_shadow_service
   run_supervisord
}

main $*
