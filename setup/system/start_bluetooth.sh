#!/bin/bash

echo -e "[\e[33mmyHouse\e[0m] Starting bluetooth..."
/etc/init.d/dbus start
/etc/init.d/bluetooth start
