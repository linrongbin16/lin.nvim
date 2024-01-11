---@diagnostic disable:redundant-return-value
local uv = vim.uv or vim.loop
local stdpath_config = vim.fn.stdpath("config")

--- @param name string
--- @param key string
--- @return string
local function user_module_filepath(name, key)
    local base = stdpath_config .. "/lua/configs/" .. name:gsub("%.", "-")
    return base .. string.format("/user_%s.lua", key)
end

--- @param name string
--- @param key string
--- @return string
local function user_module(name, key)
    local base = "configs." .. name:gsub("%.", "-")
    return base .. string.format(".user_%s", key)
end

--- @param name string
--- @param key string
--- @return string
local function default_module(name, key)
    local base = "configs." .. name:gsub("%.", "-")
    return base .. "." .. key
end

--- @param name string
--- @param key string
--- @return any
local function load_lua_module(name, key)
    local user_path = user_module_filepath(name, key)
    if uv.fs_stat(user_path) then
        return require(user_module(name, key))
    end
    return require(default_module(name, key))
end

--- @param user_script_path string
--- @param builtin_script_path string
local function load_vim_script(user_script_path, builtin_script_path)
    if uv.fs_stat(user_script_path or "") then
        vim.cmd(string.format([[source %s]], user_script_path))
    else
        vim.cmd(string.format([[source %s]], builtin_script_path))
    end
end

--- @param name string
--- @return any
local function lua_keys(name)
    return load_lua_module(name, "keys")
end

--- @param name string
local function lua_init(name)
    local function wrap()
        return load_lua_module(name, "init")
    end
    return wrap
end

--- @param init string
local function vim_init(init)
    local function wrap()
        local user_path = vim.fn.stdpath("config")
            .. "/lua/configs/"
            .. init:gsub("%.", "-")
            .. "/user_init.vim"
        local builtin_path = vim.fn.stdpath("config")
            .. "/lua/configs/"
            .. init:gsub("%.", "-")
            .. "/init.vim"
        load_vim_script(user_path, builtin_path)
    end
    return wrap
end

--- @param name string
local function lua_config(name)
    local function wrap()
        return load_lua_module(name, "config")
    end
    return wrap
end

--- @param config string
local function vim_config(config)
    local function wrap()
        local user_path = vim.fn.stdpath("config")
            .. "/lua/configs/"
            .. config:gsub("%.", "-")
            .. "/user_config.vim"
        local builtin_path = vim.fn.stdpath("config")
            .. "/lua/configs/"
            .. config:gsub("%.", "-")
            .. "/config.vim"
        load_vim_script(user_path, builtin_path)
    end
    return wrap
end

local M = {
    lua_keys = lua_keys,
    lua_init = lua_init,
    vim_init = vim_init,
    lua_config = lua_config,
    vim_config = vim_config,
}

return M
