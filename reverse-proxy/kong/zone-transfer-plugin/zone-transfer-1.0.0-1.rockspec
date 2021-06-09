package = "zone-transfer"
version = "1.0.0-1"
source = {
  url = "."
}
description = {
  summary = "A Kong custom plugin to perform dynamic user routing in global Curity deployments"
}
dependencies = {
  "lua >= 5.1"
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.zone-transfer.access"] = "access.lua",
    ["kong.plugins.zone-transfer.handler"] = "handler.lua",
    ["kong.plugins.zone-transfer.schema"] = "schema.lua"
  }
}