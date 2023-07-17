local message = require("builtin.utils.message")

local function lua_keys(keys)
    local user_path = "configs/" .. keys:gsub("%.", "-") .. "/user_keys"
    local user_ok, user_keys = pcall(require, user_path)
    if user_ok then
        return user_keys
    end
    local keys_path = "configs/" .. keys:gsub("%.", "-") .. "/keys"
    local keys_list_ok, keys_list = pcall(require, keys_path)
    if not keys_list_ok then
        message.err("Failed to load lua module '" .. keys_path .. "'!")
    end
    return keys_list
end

local function lua_init(init)
    return function()
        local user_path = "configs/" .. init:gsub("%.", "-") .. "/user_init"
        local user_ok, user_module = pcall(require, user_path)
        if user_ok then
            return user_module
        end
        local init_path = "configs/" .. init:gsub("%.", "-") .. "/init"
        local ok, init_module = pcall(require, init_path)
        if not ok then
            message.err("Failed to load lua module '" .. init_path .. "'!")
        end
        return init_module
    end
end

local function vim_init(init)
    return function()
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
end

local function lua_config(config)
    return function()
        local user_path = "configs/" .. config:gsub("%.", "-") .. "/user_config"
        local user_ok, user_module = pcall(require, user_path)
        if user_ok then
            return user_module
        end
        local config_path = "configs/" .. config:gsub("%.", "-") .. "/config"
        local ok, config_module = pcall(require, config_path)
        if not ok then
            message.err("Failed to load lua module '" .. config_path .. "'!")
        end
        return config_module
    end
end

local function vim_config(config)
    return function()
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
end

local M = {
    lua_keys = lua_keys,
    lua_init = lua_init,
    vim_init = vim_init,
    lua_config = lua_config,
    vim_config = vim_config,
}

return M