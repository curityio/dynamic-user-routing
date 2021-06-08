--
-- A LUA module to handle zone transfer for the Curity Identity Server
--

local _M = {}
local jwt = require 'resty.jwt'

--
-- Read the zone from a front channel cookie
--
local function get_zone_from_cookie(cookie_name)
  
  local zone = ngx.var['cookie_' .. cookie_name]
  if zone then
    ngx.log(ngx.INFO, "*** Found zone '" .. zone .. "' in cookie")
    return zone
  end 

  return nil
end

--
-- Try to get the name of the field containing the wrapped token
--
local function get_wrapped_token_field(args)
  
  if args['grant_type'] == 'authorization_code' then
    
    -- The authorization code field is a wrapped token
    return 'code'
  
  elseif args['grant_type'] == 'refresh_token' then

    -- The refresh token field is a wrapped token
    return 'refresh_token'

  elseif args['token'] and not args['state'] then

    -- This includes user info requests and excludes authorize requests
    return 'token'
  end

  return nil
end

--
-- Load the wrapped token / JWT and look for a claim in the payload
--
local function get_zone_claim_value(wrapped_token, claim_name)

  local jwt = jwt:load_jwt(wrapped_token)
  if jwt.valid and jwt.payload[claim_name] then
    return jwt.payload.zone
  end

  if not jwt.valid then
    ngx.log(ngx.ERR, '*** Unable to parse JWT: ' .. jwt.reason)
  end

  return nil
end

--
-- Read a token field from a form URL encoded request body
--
local function get_zone_from_form(claim_name)

  ngx.req.read_body()
  local args = ngx.req.get_post_args()
  
  local wrapped_token_field = get_wrapped_token_field(args)
  if wrapped_token_field then

    local jwt = args[wrapped_token_field]
    if jwt then

      local zone = get_zone_claim_value(jwt, claim_name)
      if zone then
        ngx.log(ngx.INFO, "*** Found zone '" .. zone .. "' in wrapped token")
        return zone
      end
    end
  end

  return nil
end

--
-- Get the zone value, depending on the OAuth message received
--
function _M.run(config)
  
  local method = string.lower(ngx.var.request_method)
  if method == 'options' or method == 'head' then
    return nil
  end

  -- First see if we can find a value in the zone cookie
  local zone = get_zone_from_cookie(config.cookie_name)

  -- Otherwise, for POST messages look in the form body
  if zone == nil then
    if method == 'post' then
      zone = get_zone_from_form(config.claim_name)
    end
  end

  -- Update the host name if a zone is found
  if zone == 'eu' then
    ngx.ctx.balancer_address.host = config.eu_host
  elseif zone == 'us' then
    ngx.ctx.balancer_address.host = config.us_host
  end
end

return _M
