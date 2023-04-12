# Dynamic User Routing

How to route OAuth requests to a user's home region, in a global deployment.\
This ensures that Personally Identifiable Information (PII) never gets stored in the wrong region.

## Install Prerequisites

- Install Docker Desktop and configure memory resources of 8GB
- Install ngrok
- Install jq
- Copy a valid `license.json` file into the idsvr folder

## Deploy the System

If you want to deploy the multi-region cluster of the Curity Identity Server using a cloud reverse proxy (e.g. a Cloudflare CDN
or Azure), then make sure to uncomment lines in `docker-compose.yml` to expose ports of the runtime nodes. Then start
the cluster with the command:

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

Once the system is up, you will have to set the base URL to the URL which points to your gateway (e.g. https://idsvr.ngrok.io).
You can do that, in the admin UI of the Curity Identity Server, in the **System** -> **General** tab. 

Then you can select 'Use Webfinger' in OAuth tools and enter the gateway URL.\
The Curity Identity Server runtime nodes are accessed via the Reverse Proxy, but they are also reachable through their \
corresponding domains. Administer the system via the admin node, signing in as user `admin` and password `Password1`.

| Component | Base URL | URL Type |
| --------- | -------- | -------- |
| Reverse Proxy | https://idsvr.ngrok.io | External |
| Curity Admin Node | https://localhost:6749/admin | External |
| Curity Europe Runtime | https://idsvr-eu.ngrok.io | External |
| Curity USA Runtime | http://idsvr-us.ngrok.io | External |

## Test Regional Logins

In OAuth Tools, run a Code Flow login for the following client, then redeem the code for tokens.\
The login will begin in the EU region, then may switch to the US region once the user is identified.

- Client ID: tools-client
- Client Secret: Password1
- Sign in as 'testuser.eu' or 'testuser.us' with password 'Password1'
- Verify from logs that you are routed to the expected Curity instance

## Configuring example Cloud Reverse Proxies

### Running the Cloudflare worker

In the `/reverse-proxy/cloudlfare-worker` folder you will find the code of an example Cloudflare worker capable of performing
the user routing. To install the worker, run `wrangler publish` from that folder. Remember to fill proper data in the
`wrangler.toml` file. At the beginning of the `index.js` file there is a map of zone IDs and URLs, which you have to
change to URLs and IDs used by your zones.

### Using Azure API Management

Use the policy found in `reverse-proxy/azure-api-management/` to configure dynamic user routing in Azure API Management.
At the beggining of the procedure you can set the default zone ID and cookie and claim names which should be used to get
the zone ID from a request. Near the end of the file you can find the section which maps zone IDs to URLs. Adjust that
according to your setup.
