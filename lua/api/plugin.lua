---@diagnostic disable:redundant-return-value
local v = require("api.v")
local stdpath_config = vim.fn.stdpath("config")

--- @param name string
--- @param key string
--- @return any
local function load_lua_module(name, key)
  local user_filepath_base = stdpath_config .. "/lua/configs/" .. name:gsub("%.", "-")
  local user_path = user_filepath_base .. string.format("/user_%s.lua", key)
  local module_base = "configs." .. name:gsub("%.", "-")

  if v.fs_stat(user_path) then
    local user_module = module_base .. string.format(".user_%s", key)
    return require(user_module)
  else
    local default_module = module_base .. "." .. key
    return require(default_module)
  end
end

--- @param name string
--- @return any
local function keys(name)
  return load_lua_module(name, "keys")
end

--- @param name string
local function init(name)
  local function wrap()
    return load_lua_module(name, "init")
  end
  return wrap
end

--- @param name string
local function config(name)
  local function wrap()
    return load_lua_module(name, "config")
  end
  return wrap
end

local M = {
  keys = keys,
  init = init,
  config = config,
}

return M
