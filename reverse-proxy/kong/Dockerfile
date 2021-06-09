FROM kong:2.4.1-alpine

USER root
RUN luarocks install lua-resty-jwt
COPY reverse-proxy/kong/zone-transfer-plugin/* /usr/local/share/lua/5.1/kong/plugins/zone-transfer/
USER kong