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
    dependencies = "rktjmp/lush.nvim",
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
    -- apprentice
    "romainl/Apprentice",
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
  {
    -- papercolor
    "NLKNguyen/papercolor-theme",
    lazy = true,
  },
  {
    -- jellybeans
    "nanotech/jellybeans.vim",
    lazy = true,
  },
  -- {
  --   -- nord
  --   -- replaced by "shaunsingh/nord.nvim"
  --   "nordtheme/vim",
  --   lazy = true,
  -- },
  -- {
  --   -- oceanic-next
  --   -- replaced by "mhartington/oceanic-next"
  --   "mhartington/oceanic-next",
  --   lazy = true,
  -- },
  {
    -- one
    "rakr/vim-one",
    lazy = true,
  },
  -- {
  --   -- onedark
  --   -- replaced by "navarasu/onedark.nvim"
  --   "joshdick/onedark.vim",
  --   lazy = true,
  -- },
  {
    -- onehalf
    "sonph/onehalf",
    lazy = true,
  },
  {
    -- seoul256
    "junegunn/seoul256.vim",
    lazy = true,
  },
  {
    -- solarized8
    "lifepillar/vim-solarized8",
    url = "https://codeberg.org/lifepillar/vim-solarized8",
    lazy = true,
  },
  {
    -- tender
    "jacoborus/tender.vim",
    lazy = true,
  },
}
