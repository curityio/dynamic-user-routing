# Dynamic User Routing

How to route OAuth requests to a user's home region, in a global deployment.\
This ensures that Personally Identifiable Information (PII) never gets stored in the wrong region.

## Install Prerequisites

- Install Docker Desktop and configure memory resources of 8GB
- Install ngrok
- Install jq
- Copy a valid `license.json` file into the idsvr folder

## Deploy the System

Run one of these commands, supplying the name of the reverse proxy you want to use.\
Copy the ngrok URL when prompted, for providing to OAuth Tools.

- ./run.sh nginx
- ./run.sh kong

Then press enter to open OAuth Tools and to deploy the Docker components.\
The Reverse Proxy will be deployed, along with Identity Server instances for EU and US regions.

## Access the System

Once the system is up, select 'Use Webfinger' in OAuth tools and enter the ngrok URL.\
The Curity Identity Server runtime nodes are accessed via the Reverse Proxy, which uses the ngrok URL.\
Administer the system via the admin node, signing in as user `admin` and password `Password1`.

| Component | Base URL | URL Type |
| --------- | -------- | -------- |
| Reverse Proxy | https://5036fca5f99d.eu.ngrok.io | External |
| Curity Admin Node | https://localhost:6749/admin | External |
| Curity Europe Runtime | http://internal-curity-eu:8443 | Internal |
| Curity USA Runtime | http://internal-curity-us:8443 | Internal |

## Test Regional Logins

In OAuth Tools, run a Code Flow login for the following client, then redeem the code for tokens.\
The login will begin in the EU region, then may switch to the US region once the user is identified.

- Client ID: tools-client
- Client Secret: Password1
- Sign in as 'testuser.eu' or 'testuser.us' with password 'Password1'
- Verify from logs that you are routed to the expected Curity instance

## View Logs

If required, run one of the following commands to view logs for some or all components:

- ./logs.sh nginx
- ./logs.sh kong
- ./logs.sh curity
- ./logs.sh all
