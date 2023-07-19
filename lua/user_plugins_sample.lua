-- Please copy this file to 'user_plugins.lua' to enable it.

-- ---- User Plugins ----

local lua_keys = require("builtin.utils.plugin").lua_keys
local lua_init = require("builtin.utils.plugin").lua_init
local lua_config = require("builtin.utils.plugin").lua_config
local vim_init = require("builtin.utils.plugin").vim_init
local vim_config = require("builtin.utils.plugin").vim_config

local VeryLazy = "VeryLazy"
local BufNewFile = "BufNewFile"
local BufReadPre = "BufReadPre"
local CmdlineEnter = "CmdlineEnter"
local VimEnter = "VimEnter"
local InsertEnter = "InsertEnter"

local M = {
    -- ---- INFRASTRUCTURE ----

    {
        "folke/lsp-colors.nvim",
    },
    {
        "neovim/nvim-lspconfig",
        config = lua_config("neovim/nvim-lspconfig"),
    },
    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },
}

return M