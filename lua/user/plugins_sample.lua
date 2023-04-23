-- ---- User Plugins ----

local const = require("cfg.const")

local function lua_config(repo)
    local function wrap()
        local config_path = "repo." .. repo:gsub("%.", "-") .. ".config"
        require(config_path)
    end
    return wrap
end

local function lua_keys(repo)
    local keys_path = "repo." .. repo:gsub("%.", "-") .. ".keys"
    return require(keys_path)
end

local function lua_init(repo)
    local function wrap()
        local init_path = "repo." .. repo:gsub("%.", "-") .. ".init"
        require(init_path)
    end
    return wrap
end

local function vim_config(repo)
    local function wrap()
        vim.cmd("source $HOME/.nvim/repo/" .. repo .. "/config.vim")
    end
    return wrap
end

local function vim_init(repo)
    local function wrap()
        vim.cmd("source $HOME/.nvim/repo/" .. repo .. "/init.vim")
    end
    return wrap
end

local VeryLazy = "VeryLazy"
local BufRead = "BufRead"
local BufNewFile = "BufNewFile"
local CmdlineEnter = "CmdlineEnter"
local VimEnter = "VimEnter"
local InsertEnter = "InsertEnter"

return {
    -- github copilot
    {
        "zbirenbaum/copilot-cmp",
        event = { VeryLazy, InsertEnter, CmdlineEnter },
    },
    {
        "zbirenbaum/copilot.lua",
        event = { VeryLazy, InsertEnter, CmdlineEnter },
    },
}