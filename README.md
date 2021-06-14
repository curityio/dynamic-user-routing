# Dynamic User Routing

How to route OAuth requests to a user's home region, in a global deployment.\
This ensures that Personally Identifiable Information (PII) never gets stored in the wrong region.

## Install Prerequisites

- Install Docker Desktop and configure memory resources of 8GB
- Install ngrok
- Install jq
- Copy a valid `license.json` file into the idsvr folder

## Deploy the System

Deploy the Reverse Proxy, along with Identity Server instances for EU and US regions.\
Run one of these commands, supplying the name of the reverse proxy you want to use:

- ./run.sh nginx
- ./run.sh kong

If required, run one of the following commands to view logs for some or all components:

- ./logs.sh nginx
- ./logs.sh kong
- ./logs.sh curity
- ./logs.sh all

## Access the System

The Curity Identity Server runtime nodes are accessed via the NGINX reverse proxy.\
Administer the system via the admin node, signing in as user `admin` and password `Password1`.

| Component | Base URL | URL Type |
| --------- | -------- | -------- |
| Reverse Proxy | https://curity-demo.ngrok.io | External |
| Curity Admin Node | https://localhost:6749/admin | External |
| Curity Europe Runtime | http://internal-curity-eu:8443 | Internal |
| Curity USA Runtime | http://internal-curity-us:8443 | Internal |

The run-script set up the Curity Identity Server to work with the proxy.

## Test Regional Logins

Browse to https://oauth.tools and add an environment from the below metadata URL:

- https://oauth.tools#new-env=https://curity-demo.ngrok.io/&webfinger=true

Run a Code Flow login for the following client, then redeem the code for tokens.\
The login will begin in the EU region, then switch to the US region once the user is identified.

- Client ID: tools-client
- Client Secret: Password1
- Sign in as 'testuser.eu' or 'testuser.us' with password 'Password1'
- Verify from logs that you are routed to the expected Curity instance
