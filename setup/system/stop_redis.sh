#!/bin/bash

echo -e "[\e[33mmyHouse\e[0m] Stopping embedded redis database..."
/etc/init.d/redis-server stop
