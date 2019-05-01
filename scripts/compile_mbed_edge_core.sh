#! /bin/sh

if [ -d /home/arm/mbed-edge ]; then
   if [ -d /home/arm/mbed-edge/build ]; then
      if [ -f /home/arm/mbed-edge/config/mbed_cloud_dev_credentials.c ]; then
           echo "Compiling mbed edge core..."
           cd /home/arm/mbed-edge
	   /bin/rm -rf build
	   mkdir build
	   cd build
           cmake -DDEVELOPER_MODE=ON -DFIRMWARE_UPDATE=OFF ..
  	   make
      else
	   echo "Pelion API Key not configured. Mbed edge core not built."
      fi
   else
      echo "Mbed edge core not configured. Not built"
   fi 
else
    echo "Mbed edge core not cloned. Not built"
fi
