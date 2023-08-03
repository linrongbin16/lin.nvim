--- @type LuaModule
local message = require("builtin.utils.message")

--- @param keys string
--- @return LazyKeySpec[]
local function lua_keys(keys)
    local user_path = "configs/" .. keys:gsub("%.", "-") .. "/user_keys"
    local user_ok, user_keys = pcall(require, user_path)
    if user_ok then
        return user_keys
    end
    local keys_path = "configs/" .. keys:gsub("%.", "-") .. "/keys"
    local keys_list_ok, keys_list = pcall(require, keys_path)
    if not keys_list_ok then
        message.err(
            string.format(
                "Failed to load lua module '%s'! %s",
                keys_path,
                vim.inspect(keys_list)
            )
        )
    end
    return keys_list
end

--- @param init string
--- @return LazyInitSpec
local function lua_init(init)
    local function wrap()
        local user_path = "configs/" .. init:gsub("%.", "-") .. "/user_init"
        local user_ok, user_module = pcall(require, user_path)
        if user_ok then
            return user_module
        end
        local init_path = "configs/" .. init:gsub("%.", "-") .. "/init"
        local ok, init_module = pcall(require, init_path)
        if not ok then
            message.err(
                string.format(
                    "Failed to load lua module '%s'! %s",
                    init_path,
                    vim.inspect(init_module)
                )
            )
        end
        return init_module
    end
    return wrap
end

--- @param init string
--- @return LazyInitSpec
local function vim_init(init)
    local function wrap()
        local user_path = vim.fn.stdpath("config")
            .. "/lua/configs/"
            .. init:gsub("%.", "-")
            .. "/user_init.vim"
        if vim.fn.filereadable(user_path) > 0 then
            vim.cmd([[source ]] .. user_path)
            return
        end
        local init_path = vim.fn.stdpath("config")
            .. "/lua/configs/"
            .. init:gsub("%.", "-")
            .. "/init.vim"
        if vim.fn.filereadable(init_path) <= 0 then
            message.err("Failed to load vimscript '" .. init_path .. "'!")
        end
        vim.cmd([[source ]] .. init_path)
    end
    return wrap
end

--- @param config string
--- @return LazyConfigSpec
local function lua_config(config)
    local function wrap()
        local user_path = "configs/" .. config:gsub("%.", "-") .. "/user_config"
        local user_ok, user_module = pcall(require, user_path)
        if user_ok then
            return user_module
        end
        local config_path = "configs/" .. config:gsub("%.", "-") .. "/config"
        local ok, config_module = pcall(require, config_path)
        if not ok then
            message.err(
                string.format(
                    "Failed to load lua module '%s'! %s",
                    config_path,
                    vim.inspect(config_module)
                )
            )
        end
        return config_module
    end
    return wrap
end

--- @param config string
--- @return LazyConfigSpec
local function vim_config(config)
    local function wrap()
        local user_path = vim.fn.stdpath("config")
            .. "/lua/configs/"
            .. config:gsub("%.", "-")
            .. "/user_config.vim"
        if vim.fn.filereadable(user_path) > 0 then
            vim.cmd([[source ]] .. user_path)
            return
        end
        local config_path = vim.fn.stdpath("config")
            .. "/lua/configs/"
            .. config:gsub("%.", "-")
            .. "/config.vim"
        if vim.fn.filereadable(config_path) <= 0 then
            message.err("Failed to load vimscript '" .. config_path .. "'!")
        end
        vim.cmd("source " .. config_path)
    end
    return wrap
end

--- @type LuaModule
local M = {
    lua_keys = lua_keys,
    lua_init = lua_init,
    vim_init = vim_init,
    lua_config = lua_config,
    vim_config = vim_config,
}

return M