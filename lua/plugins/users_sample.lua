-- ---- Users Plugins ----

-- Please uncomment belows and rename this file to 'users.lua' to enable it.

local lua_keys = require("builtin.utils.plugin").lua_keys
local lua_init = require("builtin.utils.plugin").lua_init
local lua_config = require("builtin.utils.plugin").lua_config
local vim_init = require("builtin.utils.plugin").vim_init
local vim_config = require("builtin.utils.plugin").vim_config

local VeryLazy = "VeryLazy"
local BufReadPre = "BufReadPre"
local BufNewFile = "BufNewFile"
local CmdlineEnter = "CmdlineEnter"
local VimEnter = "VimEnter"
local InsertEnter = "InsertEnter"
local UIEnter = "UIEnter"

return {
    {
        "tweekmonster/helpful.vim",
        cmd = { "HelpfulVersion" },
    },
    -- Yank
    {
        "gbprod/yanky.nvim",
        config = lua_config("gbprod/yanky.nvim"),
        keys = lua_keys("gbprod/yanky.nvim"),
    },

    -- slim
    {
        "slim-template/vim-slim",
    },
    -- Oil file manager
    {
        "stevearc/oil.nvim",
        config = lua_config("stevearc/oil.nvim"),
        keys = lua_keys("stevearc/oil.nvim"),
    },
}

-- return {}
