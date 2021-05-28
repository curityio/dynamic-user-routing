# User Regional Routing

Demonstrates a technique for routing OAuth requests for users to their home region.\
This ensures that Personally Identifiable Information (PII) never gets stored in the wrong region.

## Components

We will run the Curity Identity Server via a reverse proxy, with these base URLs.\
The NGINX external URL will be called from OAuth Tools, to enable testing.

| Component | Base URL | URL Type |
| --------- | -------- | -------- |
| NGINX OpenResty | https://curity-garcher.eu.ngrok.io | External |
| Curity Europe Runtime | http://internal-curity-eu:8443 | Internal |
| Curity USA Runtime | http://internal-curity-us:8443 | Internal |

You can also login to the admin UI via the following URLs, with user `admin` and password `Password1`:

| Component | Base URL |
| --------- | -------- |
| Curity Europe Admin | https://localhost:6749/admin |
| Curity USA Admin | https://localhost:6750/admin |

## NGROK Setup

Map port 80 to your NGROK domain, similar to the following.\
Do a search on this repo's files to replace the value with your own external facing URL for the reverse proxy:

```yaml
console_ui: false
region: eu
tunnels:
    curity:
        proto: http
        addr: 80
        hostname: curity-garcher.eu.ngrok.io
```

## Deploy the System

Then run the following script to deploy NGINX and Curity containers for EU and US regions:

- ./run.sh

Then run the following command to view logs in three separate terminals:

- ./logs.sh

## Test the System

Browse to https://oauth.tools and add an environment from the below URL:

- http://curity-garcher.eu.ngrok.io/oauth/v2/oauth-anonymous/.well-known/openid-configuration

Run a Code Flow login for this client, then redeem the code for tokens:

- Client ID: web-client
- Client Secret: Password1
- Sign in as 'testuser.eu' or 'testuser.us' with password 'Password1'
- Verify from logs that you are being routed to the correct Curity instance

Authorization codes and tokens are heart tokens, which are confidential JWTs, and contain the zone claim.

## View User Data

View user data for a region via commands such as these:

- export USERDATA_EU_CONTAINER_ID=$(docker container ls | grep curity_eu_data | awk '{print $1}')
- docker exec -it $USERDATA_EU_CONTAINER_ID bash
- export PGPASSWORD=Password1 && psql -p 5432 -d idsvr -U postgres
- select * from accounts;

## System Settings

- System / Zones is assigned a fixed value of either eu or us

## Authentication Settings

- A custom claim of Zone has been added and assigned the value eu or us
- The Zone claim is included in the openid scope
- The Claims Mapper adds the Zone claim to wrapper tokens

## Token Settings

- Under Token Service / Token Issuers select 'Use Wrapped Opaque Tokens'
