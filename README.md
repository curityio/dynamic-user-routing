# User Level Routing

Demonstrates a technique for routing OAuth requests for users to their home regions.\
This ensures that Personally Identifiable Information (PII) never gets stored in the wrong region.

## Setup

Add an entry to /etc/hosts to act as the public URL of the Reverse Proxy:

- 127.0.0.1 curity.local

The deploy components from the Docker Compose file:

- docker-compose up --force-recreate

Then do a basic test that proxying to the Curity Identity Server is contactable:

- curl http://curity.local/oauth/v2/oauth-anonymous/.well-known/openid-configuration

## View Logs

TODO: Open three terminals and run 'docker logs -f <container id>' in each.\
Avoid showing all logs in the main terminal above by using '--log-level ERROR'.\
This will work well for the video.

## Test the System

- Get the Electron version, which will be able to reach the base URL
- Use the preconfigured OAuth Client called 'web-client', which a Client Secret of 'Password1'
- Run OAuth tools and add the environment from http://curity.local/oauth/v2/oauth-anonymous/.well-known/openid-configuration
- Perform a code flow for the client, then redeem the code for token and view zone details
- Sign in as 'testuser.eu' or 'testuser.us' with password 'Password1'
- Verify from logs that you are being routed to the correct place

## Identity Server Settings

- Base URL is set to http://curity.local, which points to the reverse proxy
- Under Token Service / Token Issuers select 'Use Wrapped Opaque Tokens'
- System / Zones has a value of EU or US
- A custom claim of Zone has been added
- The Zone claim is included in the openid scope
- The Claims Mapper adds the Zone claim to wrapper tokens

## TODO

Tidy up these aspects and then start the video:

- Custom OpenResty docker image with LUA dependencies
- Finalize LUA code based on Jacob conversation
- Test end to end using OAuth Tools (Electron)
- Deliver Postgres data for EU and US users and verify that both logins work and go to correct places
- Fix the above logs issue
- Fix up LICENSE file for this repo