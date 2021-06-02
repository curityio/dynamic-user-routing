# Cookie Investigation

Some small resources to verify that messages are going through NGINX without problems.

## Configure NGROK

Point NGROK to port 80 in the same way as the multi zone setup:

```yaml
tunnels:
    curity:
        proto: http
        addr: 80
        hostname: curity-demo.ngrok.io
```

## Deploy the System

This runs NGINX in front of a Tiny NodeJS app used for debugging HTTP request issues:

- ./run.sh

## Test HTTP Requests

This command sends a curl POST with a large cookie through NGINX to the tiny app:

- ./test.sh

The [NodeJS Server Code](./tinyapp/server.js) then echoes back the cookie and also logs it.\
This proves that the NGINX configuration correctly passes cookies to the Curity Identity Server.