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
# Run NGINX in front of the Curity Europe / USA instances
#
docker-compose up --force-recreate
if [ $? -ne 0 ];
then
  echo "Docker compose problem encountered"
  exit 1
fi
