#!/bin/bash

ARG=$1
if [ "$ARG" == "" ]; then
  echo "Please specify a componment name such as 'nginx', 'kong', 'curity' or 'all'"
  exit 1
fi

if [ "$ARG" == "nginx" ] || [ "$ARG" == "all" ]; then
    open -a Terminal logs/logs-nginx.sh
fi

if [ "$ARG" == "kong" ] || [ "$ARG" == "all" ]; then
    open -a Terminal logs/logs-kong.sh
fi

if [ "$ARG" == "curity" ] || [ "$ARG" == "all" ]; then
    open -a Terminal logs/logs-curity-admin.sh
    open -a Terminal logs/logs-curity-eu.sh
    open -a Terminal logs/logs-curity-us.sh
fi