#!/bin/bash

#
# Build the custom Docker image for OpenResty
#
docker build --no-cache -f ./openresty/Dockerfile -t custom_openresty:1.19.3.1-8-bionic .
if [ $? -ne 0 ];
then
  echo "Docker build problem encountered"
  exit 1
fi

#
# Run ngrok so that we can call the local system over the internet from OAuth tools
#
ngrok start --all &
if [ $? -ne 0 ];
then
  echo "NGROK problem encountered"
  exit 1
fi

#
# Run NGINX in front of the Curity instances for Europe and USA
#
docker-compose up --force-recreate
if [ $? -ne 0 ];
then
  echo "Docker compose problem encountered"
  exit 1
fi
