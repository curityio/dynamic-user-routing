#
# A very basic docker image for the web host
#

FROM node:15.11.0-alpine

WORKDIR /usr/spa
COPY tinyapp/index.html /usr/spa
COPY tinyapp/server.js /usr/spa

CMD ["node", "server.js"]
