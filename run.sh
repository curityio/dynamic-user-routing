#!/bin/bash

#
# Get the command line parameter that specifies which gateway to use
#
GATEWAY=$1
if [ "$GATEWAY" != "nginx" ] && [ "$GATEWAY" != "kong" ]; then
  echo "Please specify 'kong' or 'nginx' as a command line argument, eg './run.sh nginx'"
  exit 1
fi

#
# Run ngrok so that we can call the local system over the internet from OAuth tools
#
kill -9 $(pgrep ngrok) 2>/dev/null
ngrok http 80  -log=stdout > /dev/null &

echo "Getting base URL from ngrok"
sleep 5
export BASE_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[] | select(.proto == "https") | .public_url')

echo "Exposing local Curity instance at $BASE_URL"
echo "To begin using this, click here: https://oauth.tools#new-env=${BASE_URL}/&webfinger=true"

#
# Run all Docker containers
#
if [ "$GATEWAY" == "nginx" ]; then

  docker-compose --profile nginx up --force-recreate --build
elif [ "$GATEWAY" == "kong" ]; then

  docker-compose --profile kong up --force-recreate --build
fi
if [ $? -ne 0 ];
then
  echo "Problem encountered running containers via Docker compose"
  exit 1
fi
