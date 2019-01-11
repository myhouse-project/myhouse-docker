#!/bin/bash

echo -e "[\e[33mmyHouse\e[0m] Stopping embedded MQTT broker..."
/etc/init.d/mosquitto stop
