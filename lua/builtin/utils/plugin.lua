local loader = require("builtin.utils.loader")

local function lua_keys(keys)
    local keys_path = "config/" .. keys:gsub("%.", "-") .. "/keys"
    local keys_ok, keys_module = loader.load(keys_path)
    if keys_ok then
        return keys_module
    else
        return nil
    end
end

local function lua_init(init)
    return function()
        local init_path = "config/" .. init:gsub("%.", "-") .. "/init"
        loader.load(init_path)
    end
end

local function vim_init(init)
    return function()
        local init_path = "config/" .. init .. "/init.vim"
        loader.load(init_path)
    end
end

local function lua_config(config)
    return function()
        local config_path = "config/" .. config:gsub("%.", "-") .. "/config"
        loader.load(config_path)
    end
end

local function vim_config(config)
    return function()
        local config_path = "config/" .. config .. "/config.vim"
        loader.load(config_path)
    end
end

local M = {
    lua_keys = lua_keys,
    lua_init = lua_init,
    vim_init = vim_init,
    lua_config = lua_config,
    vim_config = vim_config,
}

return M