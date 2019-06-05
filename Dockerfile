FROM ubuntu:18.04
MAINTAINER ARM <doug.anson@arm.com>
EXPOSE 22/tcp
EXPOSE 1883/tcp
EXPOSE 8234/tcp
EXPOSE 28175/tcp
EXPOSE 17362/tcp
RUN apt-get update
RUN apt-get -y install openjdk-8-jre vim sudo locales openssh-server supervisor dnsutils unzip zip mosquitto git libmosquitto-dev mosquitto-clients libc6-dev build-essential cmake git doxygen graphviz jq curl socat iproute2
RUN useradd arm -m -s /bin/bash 
RUN mkdir -p /home/arm
RUN chown arm.arm /home/arm
COPY ssh-keys.tar /home/arm/
COPY mosquitto.tar /home/arm/
COPY scripts.tar /home/arm/
COPY properties-editor.zip /home/arm/
COPY shadow-service.zip /home/arm/
COPY restart.sh /home/arm/
COPY configure_instance.sh /home/arm/
COPY start_instance.sh /home/arm/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY rpc.c-0.9.0 /home/arm/
RUN chmod 700 /home/arm/ssh-keys.tar
RUN chmod 700 /home/arm/mosquitto.tar
RUN chmod 700 /home/arm/shadow-service.zip
RUN chmod 700 /home/arm/properties-editor.zip
RUN chmod 700 /home/arm/configure_instance.sh
RUN chmod 700 /home/arm/start_instance.sh
RUN chmod 700 /home/arm/restart.sh
RUN /home/arm/configure_instance.sh

ENTRYPOINT [ "/home/arm/start_instance.sh" ]
