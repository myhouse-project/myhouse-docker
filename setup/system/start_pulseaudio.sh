#!/bin/bash

echo -e "[\e[33mmyHouse\e[0m] Starting audio..."
/usr/bin/pulseaudio -D --system --realtime --disallow-exit --no-cpu-limit
