#!/bin/bash

#
# Some bash commands for understanding the deployed system
#

#
# Get container ids
#
export OPENRESTY_CONTAINER_ID=$(docker container ls | grep openresty | awk '{print $1}')
export CURITY_EU_CONTAINER_ID=$(docker container ls | grep curity_eu | awk '{print $1}')
export CURITY_US_CONTAINER_ID=$(docker container ls | grep curity_us | awk '{print $1}')

#
# Ensure that openresty nginx.conf file is correct
#
# - docker exec -it $OPENRESTY_CONTAINER_ID bash -c 'cat /usr/local/openresty/nginx/conf/nginx.conf'
# 

#
# Remote to the NGINX container and make a curl request to Identity Server instances
#
# - docker exec -it $OPENRESTY_CONTAINER_ID bash
# - curl http://internal-curity-eu:8443/oauth/v2/oauth-anonymous/.well-known/openid-configuration
# - curl http://internal-curity-us:8443/oauth/v2/oauth-anonymous/.well-known/openid-configuration
#

#
# Check that Curity configuration has been deployed successfully
#
# - docker exec -it $CURITY_EU_CONTAINER_ID bash -c 'ls -l /opt/idsvr/etc/init/config.xml'
#
