local uv = vim.uv or vim.loop

--- @param user_module_path string
--- @param builtin_module_path string
--- @return any
local function load_lua_module(user_module_path, builtin_module_path)
    local user_ok, user_module = pcall(require, user_module_path)
    if user_ok then
        return user_module --[[@as table]]
    end
    return require(builtin_module_path) --[[@as table]]
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

--- @param keys string
--- @return any
local function lua_keys(keys)
    local user_path = "configs/" .. keys:gsub("%.", "-") .. "/user_keys"
    local builtin_path = "configs/" .. keys:gsub("%.", "-") .. "/keys"
    return load_lua_module(user_path, builtin_path)
end

--- @param init string
local function lua_init(init)
    local function wrap()
        local user_path = "configs/" .. init:gsub("%.", "-") .. "/user_init"
        local builtin_path = "configs/" .. init:gsub("%.", "-") .. "/init"
        return load_lua_module(user_path, builtin_path)
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

--- @param config string
local function lua_config(config)
    local function wrap()
        local user_path = "configs/" .. config:gsub("%.", "-") .. "/user_config"
        local builtin_path = "configs/" .. config:gsub("%.", "-") .. "/config"
        return load_lua_module(user_path, builtin_path)
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
