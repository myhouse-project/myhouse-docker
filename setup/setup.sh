#!/bin/bash

## Setup the system
SETUP_DIR="./setup"
chmod -R 755 $SETUP_DIR

## Set the timezone
#$SETUP_DIR/system/set_timezone.sh "Europe/Paris"

## Stop unnecessary services
#$SETUP_DIR/system/stop_redis.sh
#$SETUP_DIR/system/stop_mosquitto.sh

## Setup bluetooth speaker
#$SETUP_DIR/audio/setup_bluetooth_audio.sh
#$SETUP_DIR/system/start_bluetooth.sh
#$SETUP_DIR/system/start_pulseaudio.sh
#$SETUP_DIR/audio/connect_bluetooth_speakers.exp F5:B6:AB:45:63:C6
#$SETUP_DIR/audio/set_volume.sh "80%"

## Customize the environment
#echo -e "[\e[33mmyHouse\e[0m] Installing custom rtl_433..."
#cp $SETUP_DIR/rtl_433/rtl_433 /usr/local/bin
#chmod 755 /usr/local/bin/rtl_433
#echo -e "[\e[33mmyHouse\e[0m] Installing custom version of myHouse..."
#cp -Rf $SETUP_DIR/myHouse-dev/* ./myHouse
