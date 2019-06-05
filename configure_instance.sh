#!/bin/bash

#
# Mbed Edge Core Runtime Release
#
MBED_EDGE_RELEASE=0.9.0

setup_locale() {
   locale-gen en_US en_US.UTF-8
}

setup_shadow_service()
{
    cd /home/arm
    unzip -q ./shadow-service.zip
    /bin/rm -f ./shadow-service.zip
    chown -R arm.arm shadow-service *.sh
    chmod -R 700 shadow-service *.sh
    cp /home/arm/shadow-service/conf/properties-editor.properties /home/arm/properties-editor/conf
    cd /home/arm
    ln -s shadow-service service
}

setup_properties_editor()
{
   cd /home/arm
   /bin/rm -rf properties-editor 2>&1 1> /dev/null
   unzip -q ./properties-editor.zip
   /bin/rm -f ./properties-editor.zip
   chown -R arm.arm properties-editor
   chmod -R 700 properties-editor
   cd properties-editor/conf
   ln -s ../../shadow-service/conf/service.properties ./service.properties
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
   /bin/rm -f /home/arm/scripts.tar 2>&1 1>/dev/null
}

setup_mbed_edge_core() {
    echo "Setting up scripts directory..."
    tar xf scripts.tar
    chown -R arm.arm scripts
    chmod -R 700 scripts
    echo "Cloning mbed edge repo..."
    cd /home/arm
    git clone --branch ${MBED_EDGE_RELEASE} https://github.com/ARMmbed/mbed-edge
    cd mbed-edge
    git submodule init
    git submodule update
    mkdir build
    cd /home/arm
    cd /home/arm/service/target
    ln -s /home/arm/scripts .
    cd /home/arm
    chown -R arm.arm mbed-edge
}

patch_mbed_edge_core() {
    cd /home/arm
    mv rpc.c-${MBED_EDGE_RELEASE} mbed-edge/edge-rpc
}

main() 
{
    setup_locale
    setup_passwords
    setup_sudoers
    setup_ssh
    setup_java
    setup_mosquitto
    setup_properties_editor
    setup_shadow_service
    setup_mbed_edge_core
    patch_mbed_edge_core
    cleanup
}

main $*
