FROM openresty/openresty:1.19.3.1-8-bionic

RUN luarocks install lua-resty-jwt

COPY reverse-proxy/nginx/zonetransfer.lua /usr/local/openresty/lualib