#!/bin/bash

export OPENRESTY_CONTAINER_ID=$(docker container ls | grep openresty | awk '{print $1}')
docker logs -f $OPENRESTY_CONTAINER_ID