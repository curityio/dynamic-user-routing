# User Regional Routing

How to route OAuth requests to a user's home region, in a global deployment.\
This ensures that Personally Identifiable Information (PII) never gets stored in the wrong region.

## Install Prerequisites

Install Docker Desktop and ngrok, then copy a valid `license.json` file into the idsvr folder.

## Configure Internet Access

Map port 80 to your ngrok domain, similar to the following.\
Do a search on this repo's files and replace `curity-demo` with your own domain:

```yaml
tunnels:
    curity:
        proto: http
        addr: 80
        hostname: curity-demo.ngrok.io
```

## Deploy the System

Then run the following script to deploy NGINX and Curity docker containers for EU and US regions:

- ./run.sh

Then run the following command to view logs for each component in separate terminal windows:

- ./logs.sh

## Test the System

Browse to https://oauth.tools and add an environment from the below metadata URL:

- http://curity-demo.ngrok.io/oauth/v2/oauth-anonymous/.well-known/openid-configuration

Run a Code Flow login for the following client, then redeem the code for tokens.\
The login will begin in the EU region, then switch to the US region once the user is identified.

- Client ID: tools-client
- Client Secret: Password1
- Sign in as 'testuser.eu' or 'testuser.us' with password 'Password1'
- Verify from logs that you are routed to the expected Curity instance

Authorization Codes, Access Tokens and Refresh Tokens are configured to use a Wrapped Token format.\
These are confidential JWTs that allow reverse proxies to route requests based on the zone claim.

## Separated User Data

Query user data for the EU or US region with the following type of command:

- export USERDATA_EU_CONTAINER_ID=$(docker container ls | grep data_eu | awk '{print $1}')
- docker exec -it $USERDATA_EU_CONTAINER_ID bash
- export PGPASSWORD=Password1 && psql -p 5432 -d idsvr -U postgres
- select * from accounts;

## Curity URLs

The Curity Identity Server runtime nodes are accessed via the NGINX reverse proxy.\
Administer the system via the admin node, signing in as user `admin` and password `Password1`.

| Component | Base URL | URL Type |
| --------- | -------- | -------- |
| NGINX Reverse Proxy | http://curity-demo.ngrok.io | External |
| Curity Admin Node | https://localhost:6749/admin | External |
| Curity Europe Runtime | http://internal-curity-eu:8443 | Internal |
| Curity USA Runtime | http://internal-curity-us:8443 | Internal |
