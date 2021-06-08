FROM openresty/openresty:1.19.3.1-8-bionic

RUN luarocks install lua-resty-jwt

COPY openresty/zonetransfer.lua /usr/local/openresty/lualib