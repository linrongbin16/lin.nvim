-- ---- Users Plugins ----

local lua_keys = require("cfg.plugins_util").lua_keys
local lua_init = require("cfg.plugins_util").lua_init
local lua_config = require("cfg.plugins_util").lua_config
local vim_init = require("cfg.plugins_util").vim_init
local vim_config = require("cfg.plugins_util").vim_config

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
    -- Tags collector
    {
        "ludovicchabant/vim-gutentags",
        event = { VeryLazy, BufRead, BufNewFile },
        init = vim_init("ludovicchabant/vim-gutentags"),
    },
    -- Tags source for nvim-cmp
    {
        "quangnguyen30192/cmp-nvim-tags",
        event = { VeryLazy, InsertEnter, CmdlineEnter },
    },
}