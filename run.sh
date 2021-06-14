#!/bin/bash

#
# Get the command line parameter that specifies which gateway to use
#
GATEWAY=$1
if [ "$GATEWAY" != "nginx" ] && [ "$GATEWAY" != "kong" ]; then
  echo "Please specify 'kong' or 'nginx' as a command line argument, eg './run.sh nginx'"
  exit 1
fi

#
# Run ngrok so that we can call the local system over the internet from OAuth tools
#
kill -9 $(pgrep ngrok) 2>/dev/null
ngrok http 80  -log=stdout > /dev/null &

#
# Run all Docker containers
#
if [ "$GATEWAY" == "nginx" ]; then

  docker-compose --profile nginx up --force-recreate --build
elif [ "$GATEWAY" == "kong" ]; then

  docker-compose --profile kong up --force-recreate --build
fi
if [ $? -ne 0 ];
then
  echo "Problem encountered running containers via Docker compose"
  exit 1
fi
