FROM openresty/openresty:1.21.4.1-bionic

RUN luarocks install lua-resty-jwt

COPY reverse-proxy/nginx/zonetransfer.lua /usr/local/openresty/lualib