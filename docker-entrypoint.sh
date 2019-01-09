#!/bin/bash
set -e

MYHOUSE_CONFIG="/myHouse/config.json"
MYHOUSE_USER_CONFIG="/myHouse/conf/config.json"
MYHOUSE_CONFIG_EXAMPLE="/myHouse/config-example.json"
MYHOUSE_PRESTART="/myHouse/conf/pre-start.sh"
MYHOUSE_EXEC="/myHouse/myHouse.py"

# execute myHouse (through entrypoint)
if [ "$1" = 'myhouse' ]; then

  # start embedded redis database
  echo -e "[\e[33mmyHouse\e[0m] Starting embedded redis database..."
  /etc/init.d/redis-server start

  # load configuration file
  if [ -f $MYHOUSE_USER_CONFIG ]; then
    echo -e "[\e[33mmyHouse\e[0m] Loading provided configuration file..."
    rm -f $MYHOUSE_CONFIG
    ln -s $MYHOUSE_USER_CONFIG $MYHOUSE_CONFIG
  fi

  # if custom pre-start script exists, run it
  if [ -f $MYHOUSE_PRESTART ]; then
    echo -e "[\e[33mmyHouse\e[0m] Running pre-start script..."
    chmod 755 $MYHOUSE_PRESTART
    eval $MYHOUSE_PRESTART
  fi

  # start myHouse
  echo -e "[\e[33mmyHouse\e[0m] Waiting for database to be ready..."
  sleep 10
  echo -e "[\e[33mmyHouse\e[0m] Starting myHouse..."
  exec python $MYHOUSE_EXEC
fi

# execute the provided command
exec "$@"
