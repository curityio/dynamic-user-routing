#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"
cp ./hooks/pre-commit ./.git/hooks

#
# First check that a license file has been supplied
#
if [ ! -f './idsvr/license.json' ]; then
  echo "Please provide a license.json file in the idsvr folder in order to deploy the system"
  exit 1
fi

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
ngrok http 80 --log=stdout &
if [ $? -ne 0 ];
then
  echo "Problem encountered starting ngrok, please ensure that it is installed"
  exit 1
fi

#
# Calculate the base URL using the ngrok URL
#
echo "Getting the base URL from ngrok ..."
sleep 5
export BASE_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[] | select(.proto == "https") | .public_url')

#
# Get the user set up for testing in OAuth Tools
#
echo
echo "*** Copy this URL, then press enter to start OAuth Tools and deploy the Docker system ***"
echo "*** Wait for the Docker system to come up, select use Webfinger in OAuth Tools, then paste this URL as the resource ***"
echo $BASE_URL
read
open "https://oauth.tools#new-env=dynamic-user-routing/&webfinger=true"

#
# Start running Docker containers
#
docker compose --project-name dynamic-user-routing down
if [ "$GATEWAY" == "nginx" ]; then

  docker-compose --profile nginx up --force-recreate --build

elif [ "$GATEWAY" == "kong" ]; then

  docker-compose --profile kong up --force-recreate --build

fi
if [ $? -ne 0 ]; then
  echo "Problem encountered running the Docker compose system"
  exit 1
fi