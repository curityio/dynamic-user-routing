#!/bin/bash

export NGINX_CONTAINER_ID=$(docker container ls | grep openresty | awk '{print $1}')
docker logs -f $NGINX_CONTAINER_ID