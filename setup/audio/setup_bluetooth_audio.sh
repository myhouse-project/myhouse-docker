#!/bin/bash

echo -e "[\e[33mmyHouse\e[0m] Configuring bluetooth audio..."
echo "default-server = /var/run/pulse/native" >> /etc/pulse/client.conf
echo "autospawn = no" >> /etc/pulse/client.conf
echo "flat-volumes = no" >> /etc/pulse/daemon.conf
echo "### Bluetooth Support" >> /etc/pulse/system.pa
echo ".ifexists module-bluetooth-discover.so" >> /etc/pulse/system.pa
echo "load-module module-bluetooth-discover" >> /etc/pulse/system.pa
echo ".endif" >> /etc/pulse/system.pa
echo ".ifexists module-bluetooth-policy.so" >> /etc/pulse/system.pa
echo "load-module module-bluetooth-policy" >> /etc/pulse/system.pa
echo ".endif" >> /etc/pulse/system.pa
echo "# automatically switch to newly-connected devices" >> /etc/pulse/system.pa
echo "load-module module-switch-on-connect" >> /etc/pulse/system.pa
echo "load-module module-card-restore" >> /etc/pulse/system.pa
usermod -a -G pulse-access root
