#!/bin/bash

#
# Build the custom Docker image for OpenResty
#
docker build --no-cache -f ./openresty/Dockerfile -t custom_openresty:1.19.3.1-8-bionic .
if [ $? -ne 0 ];
then
  echo "Docker Openresty build problem encountered"
  exit 1
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
# Run all Docker containers with nginx / openresty as the reverse proxy
# Alternatively you can use openresty=0 to use Kong as the reverse proxy
#
docker-compose up --force-recreate --scale kong=0
if [ $? -ne 0 ];
then
  echo "Docker compose problem encountered"
  exit 1
fi
