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
# Build the custom Docker image for NGINX
#
if [ "$GATEWAY" == "nginx" ]; then
  docker build --no-cache -f ./reverse-proxy/nginx/Dockerfile -t custom_openresty:1.19.3.1-8-bionic .
  if [ $? -ne 0 ];
  then
    echo "Docker NGINX build problem encountered"
    exit 1
  fi
fi

#
# Build the custom Docker image for Kong
#
if [ "$GATEWAY" == "kong" ]; then
  docker build --no-cache -f ./reverse-proxy/kong/Dockerfile -t custom_kong:2.4.1 .
  if [ $? -ne 0 ];
  then
    echo "Docker Kong build problem encountered"
    exit 1
  fi
fi

#
# Run ngrok so that we can call the local system over the internet from OAuth tools
#
kill -9 $(pgrep ngrok) 2>/dev/null
ngrok start --all &
if [ $? -ne 0 ];
then
  echo "NGROK problem encountered"
  exit 1
fi

#
# Run all Docker containers
#
if [ "$GATEWAY" == "nginx" ]; then

  # When running NGINX we run zero instances of Kong
  docker-compose up --force-recreate --scale kong=0

elif [ "$GATEWAY" == "kong" ]; then

  # When running Kong we run zero instances of NGINX
  docker-compose up --force-recreate --scale nginx=0
fi
if [ $? -ne 0 ];
then
  echo "Problem encountered running containers via Docker compose"
  exit 1
fi
