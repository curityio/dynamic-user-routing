# User Regional Routing

Routing OAuth requests to a user's home region, in a global deployment.\
This ensures that Personally Identifiable Information (PII) never gets stored in the wrong region.

## Prerequisites

Install Docker Desktop and ngrok.

## NGROK Setup

Map port 80 to your NGROK domain, similar to the following.\
Do a search on this repo's files to replace `curity-demo` with your own domain:

```yaml
console_ui: false
region: eu
tunnels:
    curity:
        proto: http
        addr: 80
        hostname: curity-demo.ngrok.io
```

## Deploy the System

Then run the following script to deploy NGINX and Curity docker containers for EU and US regions:

- ./run.sh

Then run the following command to view logs in three separate terminals:

- ./logs.sh

## Test the System

Browse to https://oauth.tools and add an environment from the below URL:

- http://curity-demo.ngrok.io/oauth/v2/oauth-anonymous/.well-known/openid-configuration

Run a Code Flow login for the following client, then redeem the code for tokens:

- Client ID: tools-client
- Client Secret: Password1
- Sign in as 'testuser.eu' or 'testuser.us' with password 'Password1'
- Verify from logs that you are being routed to the correct Curity instance

OAuth tools shows that Authorization codes and Access Tokens are Heart Tokens.\
These are confidential JWTs that allow gateways to route requests based on the zone claim.

## View User Data

View user data for the EU or US region with the following type of command:

- export USERDATA_EU_CONTAINER_ID=$(docker container ls | grep data_eu | awk '{print $1}')
- docker exec -it $USERDATA_EU_CONTAINER_ID bash
- export PGPASSWORD=Password1 && psql -p 5432 -d idsvr -U postgres
- select * from accounts;

## URLs

The Curity Identity Server instances are accessed via the reverse proxy:

| Component | Base URL | URL Type |
| --------- | -------- | -------- |
| NGINX Reverse Proxy | https://curity-demo.ngrok.io | External |
| Curity Europe Runtime | http://internal-curity-eu:8443 | Internal |
| Curity USA Runtime | http://internal-curity-us:8443 | Internal |

Login to the Admin UI via the following URLs, with user `admin` and password `Password1`:

| Component | Base URL |
| --------- | -------- |
| Curity Europe Admin | https://localhost:6749/admin |`
| Curity USA Admin | https://localhost:6750/admin |