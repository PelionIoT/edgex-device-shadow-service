#!/bin/bash

setup_locale() {
   locale-gen en_US en_US.UTF-8
}

setup_hosts() {
    echo "151.101.36.162 registry.npmjs.com" >> /etc/hosts
    echo "151.101.36.162 registry.npmjs.org" >> /etc/hosts
}

setup_shadow_service()
{
    cd /home/arm
    unzip -q ./shadow-service.zip
    /bin/rm -f ./shadow-service.zip
    chown -R arm.arm shadow-service *.sh
    chmod -R 700 shadow-service *.sh
}

setup_configurator()
{
   cd /home/arm
   ln -s shadow-service mds
   /bin/rm -rf configurator 2>&1 1> /dev/null
   unzip -q ./configurator-1.0.zip
   /bin/rm -f ./configurator-1.0.zip
   chown -R arm.arm configurator
   chmod -R 700 configurator
   cd configurator/conf
   if [ -f gateway.properties ]; then
       rm gateway.properties 2>&1 1> /dev/null
   fi
   ln -s ../../shadow-service/conf/shadow-service.properties ./gateway.properties
   cd ../..
}

setup_ssh()
{
    cd /home/arm
    tar xpf ssh-keys.tar
    /bin/rm -f ssh-keys.tar
    mkdir /var/run/sshd
    chmod 600 .ssh/*
    chmod 700 .ssh
    echo "MaxAuthTries 10" >> /etc/ssh/sshd_config
}

setup_passwords()
{
    echo "root:arm1234" | chpasswd
    echo "arm:arm1234" | chpasswd
}

setup_sudoers() 
{
    usermod -aG sudo arm
    echo "%arm ALL=NOPASSWD: ALL" >> /etc/sudoers
}

setup_nodered() {
   echo "Setting up Node-RED..."
   cd /home/arm
   # sudo ln -s /usr/bin/nodejs /usr/bin/node
   sudo npm install -g --unsafe-perm node-red
}

setup_mosquitto() {
    echo "Setting up mosquitto MQTT Broker..."
    cd /etc
    sudo tar xpf /home/arm/mosquitto.tar
    chown root.root /etc/mosquitto/*.conf /etc/mosquitto/passwd
    chmod 640 /etc/mosquitto/*.conf /etc/mosquitto/passwd 
    sudo rm -f /home/arm/mosquitto.tar 2>&1 1>/dev/null
}

setup_java() {
    echo "Using defaulted JRE..."
}

cleanup()
{
   /bin/rm -f /home/arm/configure_instance.sh 2>&1 1>/dev/null
}

main() 
{
    setup_locale
    setup_passwords
    setup_sudoers
    setup_ssh
    setup_java
    setup_shadow_service
    setup_configurator
    setup_mosquitto
    setup_hosts
    # setup_nodered
    cleanup
}

main $*
