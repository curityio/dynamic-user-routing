--
-- A LUA module to handle zone transfer for the Curity Identity Server
--

local _M = {}
local jwt = require 'resty.jwt'

--
-- Ensure that the expected options have been received
--
local function options_error(value)
  ngx.log(ngx.ERR, "*** No option for '" .. value .. "' was supplied to the zone transfer plugin")
end

--
-- Ensure that the expected options have been received
--
local function verify_options(opts)

  if not opts then
    options_error('options object')
    return false
  end

  if not opts.cookie_name then
    options_error('cookie_name')
    return false
  end

  if not opts.claim_name then
    options_error('claim_name')
    return false
  end

  return true
end

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
-- Try to get the name of the field containing the heart token
--
local function get_heart_token_field(args)
  
  if args['grant_type'] == 'authorization_code' then
    
    -- The authorization code field is a heart token
    return 'code'
  
  elseif args['grant_type'] == 'refresh_token' then

    -- The refresh token field is a heart token
    return 'refresh_token'

  elseif args['token'] and not args['state'] then

    -- This includes user info requests and excludes authorize requests
    return 'token'
  end

  return nil
end

--
-- Load the heart token / JWT and look for a claim in the payload
--
local function get_zone_claim_value(heart_token, claim_name)

  local jwt = jwt:load_jwt(heart_token)
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
  
  local heart_token_field = get_heart_token_field(args)
  if heart_token_field then

    local jwt = args[heart_token_field]
    if jwt then

      local zone = get_zone_claim_value(jwt, claim_name)
      if zone then
        ngx.log(ngx.INFO, "*** Found zone '" .. zone .. "' in heart token")
        return zone
      end
    end
  end

  return nil
end

--
-- Get the zone value, depending on the OAuth message received
--
function _M.get_zone_value(opts)
  
  if not verify_options(opts) then
    return nil
  end
  
  local method = string.lower(ngx.var.request_method)
  if method == 'options' or method == 'head' then
    return nil
  end

  -- First see if we can find a value in the zone cookie
  local zone = get_zone_from_cookie(opts.cookie_name)

  -- Otherwise, for POST messages look in the form body
  if zone == nil then
    if method == 'post' then
      zone = get_zone_from_form(opts.claim_name)
    end
  end

  return zone
end

return _M
