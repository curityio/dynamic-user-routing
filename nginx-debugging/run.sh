#!/bin/bash

#
# Build the custom Docker image for OpenResty
#
docker build --no-cache -f openresty/Dockerfile -t custom_openresty:1.19.3.1-8-bionic .
if [ $? -ne 0 ];
then
  echo "Docker build problem encountered"
  exit 1
fi

#
# Build the custom Docker image for the tiny app we use for debugging
#
docker build --no-cache -f tinyapp/Dockerfile -t tinyapp:v1 .
if [ $? -ne 0 ];
then
  echo "Tiny app build problem encountered"
  exit 1
fi

#
# Run ngrok so that we can call the local system over an internet URL, as for the multi zone setup
#
ngrok start --all &
if [ $? -ne 0 ];
then
  echo "NGROK problem encountered"
  exit 1
fi

#
# Run the cluster
#
docker-compose up --force-recreate
if [ $? -ne 0 ];
then
  echo "Docker compose problem encountered"
  exit 1
fi