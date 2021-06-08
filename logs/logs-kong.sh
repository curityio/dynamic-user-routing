#!/bin/bash

export KONG_CONTAINER_ID=$(docker container ls | grep kong | awk '{print $1}')
docker logs -f $KONG_CONTAINER_ID