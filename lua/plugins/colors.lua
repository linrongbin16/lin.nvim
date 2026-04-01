-- ---- Colorschemes ----

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

-- Collect from:
--
-- Neovim Colors: <https://www.trackawesomelist.com/rockerBOO/awesome-neovim/readme/>
-- Vim Colors: <https://github.com/rafi/awesome-vim-colorschemes>
--
-- Only github stars >= 800 are picked.

return {
  -- ---- NEOVIM COLORS ----

  {
    "rktjmp/lush.nvim",
    lazy = true,
  },
  {
    -- codedark
    "tomasiser/vim-code-dark",
    lazy = true,
  },
  {
    -- vscode
    "Mofiqul/vscode.nvim",
    lazy = true,
  },
  {
    -- material
    "marko-cerovac/material.nvim",
    lazy = true,
  },
  {
    -- nightly
    "bluz71/vim-nightfly-colors",
    lazy = true,
  },
  {
    -- moonfly
    "bluz71/vim-moonfly-colors",
    lazy = true,
  },
  {
    -- tokyonight
    "folke/tokyonight.nvim",
    lazy = true,
  },
  {
    -- sonokai
    "sainnhe/sonokai",
    lazy = true,
  },
  {
    -- oxocarbon
    "nyoom-engineering/oxocarbon.nvim",
    lazy = true,
  },
  {
    -- oceanic-next
    "mhartington/oceanic-next",
    lazy = true,
  },
  {
    -- edge
    "sainnhe/edge",
    lazy = true,
  },
  {
    -- melange
    "savq/melange-nvim",
    lazy = true,
  },
  {
    -- falcon
    "fenetikm/falcon",
    lazy = true,
  },
  {
    -- nordic
    "AlexvZyl/nordic.nvim",
    lazy = true,
  },
  {
    -- nord
    "shaunsingh/nord.nvim",
    lazy = true,
  },
  {
    -- onedark
    "navarasu/onedark.nvim",
    lazy = true,
  },
  {
    -- gruvbox-material
    "sainnhe/gruvbox-material",
    lazy = true,
  },
  {
    -- everforest
    "sainnhe/everforest",
    lazy = true,
  },
  {
    -- dracula
    "dracula/vim",
    lazy = true,
  },
  {
    -- github
    "projekt0n/github-nvim-theme",
    lazy = true,
  },
  {
    -- rose-pine
    "rose-pine/neovim",
    lazy = true,
  },
  {
    -- zenbones
    "zenbones-theme/zenbones.nvim",
    lazy = true,
  },
  {
    -- catppuccin
    "catppuccin/nvim",
    lazy = true,
  },
  {
    -- nightfox
    "EdenEast/nightfox.nvim",
    lazy = true,
  },
  {
    -- cyberdream
    "scottmckendry/cyberdream.nvim",
    lazy = true,
  },
  {
    -- gruvbox
    "ellisonleao/gruvbox.nvim",
    lazy = true,
  },

  -- ---- VIM COLORS ----

  {
    -- ayu
    "ayu-theme/ayu-vim",
    lazy = true,
  },
  {
    -- deus
    "ajmwagar/vim-deus",
    lazy = true,
  },
  {
    -- gotham
    "whatyouhide/vim-gotham",
    lazy = true,
  },
  -- {
  --   -- gruvbox
  --   -- replaced by "ellisonleao/gruvbox.nvim"
  --   "morhetz/gruvbox",
  --   lazy = true,
  -- },
  {
    -- iceberg
    "cocopon/iceberg.vim",
    lazy = true,
  },
}
