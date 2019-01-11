#!/bin/bash
set -e

MYHOUSE="$WORKDIR/myHouse"
MYHOUSE_SCRIPT="$MYHOUSE/myHouse.py"
CONFIG="$MYHOUSE/config.json"
CONFIG_MOUNT="/conf/config.json"
CONFIG_EXAMPLE="$MYHOUSE/config-example.json"
LOGS="$MYHOUSE/logs"
LOGS_MOUNT="/logs"
DB="/var/lib/redis"
DB_MOUNT="/data"
SETUP="$WORKDIR/setup"
SETUP_MOUNT="/setup"
SETUP_SCRIPT="$SETUP/setup.sh"
SETUP_DONE="/.setup_done"

# welcome message
echo
echo -e "\e[37;42m              \e[0m"
echo -e "\e[1;37;42m myHouse v$MYHOUSE_VERSION \e[0m"
echo -e "\e[37;42m              \e[0m"
echo

# execute myHouse (through entrypoint)
if [ "$1" = 'myHouse' ]; then

  # load/reload user configuration file
  if [ -f $CONFIG_MOUNT ]; then
    echo -e "[\e[33mmyHouse\e[0m] Loading user configuration file..."
    rm -f $CONFIG
    ln -s $CONFIG_MOUNT $CONFIG
  else
    echo -e "[\e[43mmyHouse\e[0m] Using example configuration file; be sure to place your own config.json into /conf"
  fi

  if [ ! -f $SETUP_DONE ]; then
    # container setup
    echo -e "[\e[33mmyHouse\e[0m] Setting up the container..."
    # from v2.0.2 gtts-cli.py has been renamed into gtts-cli
    ln -s /usr/local/bin/gtts-cli /usr/local/bin/gtts-cli.py
    # map myHouse logs directory with the mounted directory
    rm -rf $LOGS
    ln -s $LOGS_MOUNT $LOGS
    # map redis database directory with the mounted directory
    rm -rf $DB
    ln -s $DB_MOUNT $DB
    chown -R redis.redis $DB_MOUNT
    chown -R redis.redis /var/log/redis
    # this prevent running the same script again if the container is restarted
    touch $SETUP_DONE

    # run custom setup script
    echo -e "[\e[33mmyHouse\e[0m] Running custom setup script..."
    if [ "$(ls -A $SETUP_MOUNT)" ]; then
      cp -Rf $SETUP_MOUNT/* $SETUP
    fi
    chmod 755 $SETUP_SCRIPT
    eval $SETUP_SCRIPT
  else
    echo -e "[\e[43mmyHouse\e[0m] Container already configured"
  fi

  # start dependencies unless otherwise specificed
  if [ -z "$NO_REDIS" ]; then
    echo -e "[\e[33mmyHouse\e[0m] Starting embedded redis database..."
    /etc/init.d/redis-server start
  fi
  if [ -z "$NO_MQTT" ]; then
    echo -e "[\e[33mmyHouse\e[0m] Starting embedded MQTT broker..."
    /etc/init.d/mosquitto start
  fi

  # start myHouse
  if [ -z "$NO_WAIT" ]; then
    echo -e "[\e[33mmyHouse\e[0m] Waiting for database to be up and running..."
    sleep 10
  fi
  echo -e "[\e[33mmyHouse\e[0m] Starting myHouse..."
  exec python $MYHOUSE_SCRIPT
fi

# execute the provided command
exec "$@"
