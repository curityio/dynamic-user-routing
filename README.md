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
When prompted, copy the ngrok URL, such as https://5036fca5f99d.eu.ngrok.io, for providing to OAuth Tools:

```bash
./run.sh nginx
./run.sh kong
```

Then press enter to open OAuth Tools and to deploy the Docker components.\
The reverse proxy will be deployed, along with Curity Identity Server instances for EU and US regions.

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

The console outputs logs for all components, whose docker IDs can be retrieved with these commands:

```bash
export CURITY_EU_CONTAINER_ID=$(docker container ls | grep curity_eu | awk '{print $1}')
export CURITY_US_CONTAINER_ID=$(docker container ls | grep curity_us | awk '{print $1}')
export KONG_CONTAINER_ID=$(docker container ls | grep kong | awk '{print $1}')
export NGINX_CONTAINER_ID=$(docker container ls | grep openresty | awk '{print $1}')
```

To view proxy server logs in a separate terminal window, use a command of this form:

```bash
docker logs -f $NGINX_CONTAINER_ID
```

## Cloud Reverse Proxies

If you use a cloud reverse proxy, have a look at the [CLOUD.md](CLOUD.md) document to learn how to configure dynamic user
routing in such a case.

## Website Documentation

See the Curity website resources for further information:

- [Dynamic User Routing Design](https://curity.io/resources/learn/dynamic-user-routing/)
- [Implementing Dynamic User Routing](https://curity.io/resources/learn/implementing-dynamic-user-routing/)

## More Information

Please visit [curity.io](https://curity.io/) for more information about the Curity Identity Server.
