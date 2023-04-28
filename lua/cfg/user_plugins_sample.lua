-- ---- Users Plugins ----

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

local VeryLazy = "VeryLazy"
local BufRead = "BufRead"
local BufNewFile = "BufNewFile"
local CmdlineEnter = "CmdlineEnter"
local VimEnter = "VimEnter"
local InsertEnter = "InsertEnter"

return {
    -- Copilot
    {
        "zbirenbaum/copilot-cmp",
        event = { VeryLazy, InsertEnter, CmdlineEnter },
        config = lua_config("zbirenbaum/copilot-cmp"),
    },
    {
        "zbirenbaum/copilot.lua",
        event = { VeryLazy, InsertEnter, CmdlineEnter },
        config = lua_config("zbirenbaum/copilot.lua"),
    },
    -- Cmp tags source
    {
        "quangnguyen30192/cmp-nvim-tags",
        event = { VeryLazy, InsertEnter, CmdlineEnter },
    },
    -- Generate documents
    {
        "kkoomen/vim-doge",
        cmd = { "DogeGenerate" },
        build = require("cfg.const").os.is_macos
                and "npm i --no-save && npm run build:binary:unix"
            or ":call doge#install()",
        init = vim_init("kkoomen/vim-doge"),
        keys = lua_keys("kkoomen/vim-doge"),
    },
    -- Undo tree
    {
        "mbbill/undotree",
        event = { VeryLazy, CmdlineEnter },
        init = lua_init("mbbill/undotree"),
        keys = lua_keys("mbbill/undotree"),
    },
    -- Buffer manager
    {
        "j-morano/buffer_manager.nvim",
        config = lua_config("j-morano/buffer_manager.nvim"),
        keys = lua_keys("j-morano/buffer_manager.nvim"),
    },
}