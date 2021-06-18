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

### Deploy without a reverse proxy

If you want to deploy the multi-region cluster of the Curity Identity Server without any reverse proxy (e.g. to use it 
with an online Gateway like Cloudflare), then make sure to uncomment lines in `docker-compose.yml` to expose ports of
the runtime nodes. Then start the cluster with the command:

```bash
docker-compose up curity_eu curity_us
```

Then you can expose the zones with ngrok by using the following configuration. You can omit the `hostname` parameter if
you don't use named domains with ngrok. Ngrok will assign random names to your domains.

```yaml
console_ui: false
tunnels:
    curity_us:
        proto: http
        addr: 8444
        hostname: idsvr-us.ngrok.io
    curity_eu:
        proto: http
        addr: 8443
        hostname: idsvr-eu.ngrok.io
```

You should then access the system using the URL which points to your gateway. You will also have to change the base URL
of the Curity Identity Server in the **System** -> **General** tab. Set it to the URL which points to your gateway.

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

## Running the Cloudflare worker

In the `cloudlfare-worker` folder you will find the code of an example Cloudflare worker capable of performing the user routing.
To install the worker run `wrangler publish` from that folder. Remember to fill proper data in the `wrangler.toml` file.
At the beginning of the `index.js` file there is a map of zone ids and URLs, which you have to properly set to URLs used
by your zones.
