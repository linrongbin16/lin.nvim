local function lua_keys(keys)
    local keys_path = "configs." .. keys:gsub("%.", "-") .. ".keys"
    return require(keys_path)
end

local function lua_init(init)
    return function()
        local init_path = "configs." .. init:gsub("%.", "-") .. ".init"
        require(init_path)
    end
end

local function vim_init(init)
    return function()
        local init_path = "configs/" .. init:gsub("%.", "-") .. "/init.vim"
        vim.cmd("source $HOME/.nvim/lua/" .. init_path)
    end
end

local function lua_config(config)
    return function()
        local config_path = "configs." .. config:gsub("%.", "-") .. ".config"
        require(config_path)
    end
end

local function vim_config(config)
    return function()
        local config_path = "configs/"
            .. config:gsub("%.", "-")
            .. "/config.vim"
        vim.cmd("source $HOME/.nvim/lua/" .. config_path)
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