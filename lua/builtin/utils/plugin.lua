local function lua_keys(keys)
    local keys_path = "configs/" .. keys:gsub("%.", "-") .. "/keys"
    local keys_list_ok, keys_list = pcall(require, keys_path)
    if not keys_list_ok then
        error("Error! Lua module '" .. keys_path .. "' not found!")
    end
    local user_keys_path = "configs/" .. keys:gsub("%.", "-") .. "/user_keys"
    local user_keys_list_ok, user_keys_list = pcall(require, user_keys_path)
    if user_keys_list_ok and type(user_keys_list) == "table" then
        for _, k in ipairs(user_keys_list) do
            table.insert(keys_list, k)
        end
    end
    return keys_list
end

local function lua_init(init)
    return function()
        local init_path = "configs/" .. init:gsub("%.", "-") .. "/init"
        local ok, init_module = pcall(require, init_path)
        if not ok then
            error("Error! Lua module '" .. init_path .. "' not found!")
        end
        return init_module
    end
end

local function vim_init(init)
    return function()
        local init_path = "$HOME/.nvim/lua/configs/"
            .. init:gsub("%.", "-")
            .. "/init.vim"
        if not vim.fn.filereadable(vim.fn.expand(init_path)) then
            error("Error! Vimscript '" .. init_path .. "' not found!")
        end
        vim.cmd("source " .. init_path)
    end
end

local function lua_config(config)
    return function()
        local config_path = "configs/" .. config:gsub("%.", "-") .. "/config"
        local ok, config_module = pcall(require, config_path)
        if not ok then
            error("Error! Lua module '" .. config_path .. "' not found!")
        end
        return config_module
    end
end

local function vim_config(config)
    return function()
        local config_path = "$HOME/.nvim/lua/configs/"
            .. config:gsub("%.", "-")
            .. "/config.vim"
        if not vim.fn.filereadable(vim.fn.expand(config_path)) then
            error("Error! Vimscript '" .. config_path .. "' not found!")
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