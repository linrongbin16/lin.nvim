local function lua_config(repo)
    return function()
        local config_path = "repo." .. repo:gsub("%.", "-") .. ".config"
        require(config_path)
    end
end

local function lua_keys(repo)
    local keys_path = "repo." .. repo:gsub("%.", "-") .. ".keys"
    return require(keys_path)
end

local function lua_init(repo)
    return function()
        local init_path = "repo." .. repo:gsub("%.", "-") .. ".init"
        require(init_path)
    end
end

local function vim_config(repo)
    return function()
        vim.cmd("source $HOME/.nvim/repo/" .. repo .. "/config.vim")
    end
end

local function vim_init(repo)
    return function()
        vim.cmd("source $HOME/.nvim/repo/" .. repo .. "/init.vim")
    end
end

local M = {
    lua_keys = lua_keys,
    lua_config = lua_config,
    lua_init = lua_init,
    vim_init = vim_init,
    vim_config = vim_config,
}

return M