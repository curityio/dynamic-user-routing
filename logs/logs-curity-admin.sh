#!/bin/bash

export CURITY_ADMIN_CONTAINER_ID=$(docker container ls | grep curity_admin | awk '{print $1}')
docker logs -f $CURITY_ADMIN_CONTAINER_ID