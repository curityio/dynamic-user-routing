#!/bin/bash

export CURITY_US_CONTAINER_ID=$(docker container ls | grep curity_us | awk '{print $1}')
docker logs -f $CURITY_US_CONTAINER_ID