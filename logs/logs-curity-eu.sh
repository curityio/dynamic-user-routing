#!/bin/bash

export CURITY_EU_CONTAINER_ID=$(docker container ls | grep curity_eu | awk '{print $1}')
docker logs -f $CURITY_EU_CONTAINER_ID