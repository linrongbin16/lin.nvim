---@diagnostic disable:redundant-return-value
local uv = vim.uv or vim.loop
local stdpath_config = vim.fn.stdpath("config")

--- @param name string
--- @param key string
--- @return any
local function load_lua_module(name, key)
    local user_filepath_base = stdpath_config .. "/lua/configs/" .. name:gsub("%.", "-")
    local user_path = user_filepath_base .. string.format("/user_%s.lua", key)
    local module_base = "configs." .. name:gsub("%.", "-")

    if uv.fs_stat(user_path) then
        local user_module = module_base .. string.format(".user_%s", key)
        return require(user_module)
    else
        local default_module = module_base .. "." .. key
        return require(default_module)
    end
end

--- @param name string
--- @param key string
local function load_vim_script(name, key)
    local filepath_base = stdpath_config .. "/lua/configs/" .. name:gsub("%.", "-")
    local user_path = filepath_base .. string.format("/user_%s.vim", key)

    if uv.fs_stat(user_path) then
        vim.cmd(string.format([[source %s]], user_path))
    else
        local default_path = filepath_base .. string.format("/%s,vim", key)
        vim.cmd(string.format([[source %s]], default_path))
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

--- @param name string
local function vim_init(name)
    local function wrap()
        load_vim_script(name, "init")
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

--- @param name string
local function vim_config(name)
    local function wrap()
        load_vim_script(name, "config")
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
