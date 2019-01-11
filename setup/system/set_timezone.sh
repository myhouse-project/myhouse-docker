#!/bin/bash

echo -e "[\e[33mmyHouse\e[0m] Setting timezone..."
echo "$1" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
