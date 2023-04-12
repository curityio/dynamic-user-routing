--
-- The Kong entry point handler
--

local access = require "kong.plugins.zone-transfer.access"

-- See https://github.com/Kong/kong/discussions/7193 for more about the PRIORITY field
local ZoneTransfer = {
    PRIORITY = 1000,
    VERSION = "1.0.0",
}

function ZoneTransfer:access(conf)
    access.run(conf)
end

return ZoneTransfer
