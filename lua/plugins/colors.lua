-- ---- Colorschemes ----

local lua_keys = require("builtin.utils.plugin").lua_keys
local lua_init = require("builtin.utils.plugin").lua_init
local lua_config = require("builtin.utils.plugin").lua_config
local vim_init = require("builtin.utils.plugin").vim_init
local vim_config = require("builtin.utils.plugin").vim_config
local uv = vim.uv or vim.loop

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

local all_colors = {
  -- ---- NEOVIM COLORS ----
  {
    "tomasiser/vim-code-dark",
    "codedark",
  },
  {
    "Mofiqul/vscode.nvim",
    "vscode",
  },
  {
    "marko-cerovac/material.nvim",
    "material",
  },
  {
    "bluz71/vim-nightfly-colors",
    "nightly",
  },
  {
    "bluz71/vim-moonfly-colors",
    "moonfly",
  },
  {
    "folke/tokyonight.nvim",
    "tokyonight",
  },
  {
    "rebelot/kanagawa.nvim",
    "kanagawa",
  },
  {
    "kepano/flexoki",
    "flexoki",
  },
  {
    "vague-theme/vague.nvim",
    "vague",
  },
  -- {
  --   -- replaced by "navarasu/onedark.nvim"
  --   "olimorris/onedarkpro.nvim",
  --   "onedark",
  -- },
  {
    "craftzdog/solarized-osaka.nvim",
    "solarized-osaka",
  },
  {
    "sainnhe/sonokai",
    "sonokai",
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    "oxocarbon",
  },
  {
    "mhartington/oceanic-next",
    "OceanicNext",
  },
  {
    "sainnhe/edge",
    "edge",
  },
  {
    "savq/melange-nvim",
    "melange",
  },
  {
    "fenetikm/falcon",
    "falcon",
  },
  {
    "AlexvZyl/nordic.nvim",
    "nordic",
  },
  {
    "shaunsingh/nord.nvim",
    "nord",
  },
  {
    "navarasu/onedark.nvim",
    "onedark",
  },
  {
    "sainnhe/gruvbox-material",
    "gruvbox-material",
  },
  {
    "sainnhe/everforest",
    "everforest",
  },
  {
    "dracula/vim",
    "dracula",
  },
  {
    "projekt0n/github-nvim-theme",
    "github_dark",
  },
  {
    "rose-pine/neovim",
    "rose-pine",
  },
  {
    "zenbones-theme/zenbones.nvim",
    "zenbones",
    dependencies = "rktjmp/lush.nvim",
  },
  {
    "catppuccin/nvim",
    "catppuccin",
    name = "catppuccin",
  },
  {
    "EdenEast/nightfox.nvim",
    "nightfox",
  },
  {
    "scottmckendry/cyberdream.nvim",
    "cyberdream",
  },
  {
    "ellisonleao/gruvbox.nvim",
    "gruvbox",
  },

  -- ---- VIM COLORS ----
  {
    "ayu-theme/ayu-vim",
    "ayu",
  },
  {
    "romainl/Apprentice",
    "apprentice",
  },
  {
    "ajmwagar/vim-deus",
    "deus",
  },
  {
    "whatyouhide/vim-gotham",
    "gotham",
  },
  -- {
  --   -- gruvbox
  --   -- replaced by "ellisonleao/gruvbox.nvim"
  --   "morhetz/gruvbox",
  --   lazy = true,
  -- },
  {
    "cocopon/iceberg.vim",
    "iceberg",
  },
  {
    "NLKNguyen/papercolor-theme",
    "PaperColor",
  },
  {
    "nanotech/jellybeans.vim",
    "jellybeans",
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
    "rakr/vim-one",
    "one",
  },
  -- {
  --   -- onedark
  --   -- replaced by "navarasu/onedark.nvim"
  --   "joshdick/onedark.vim",
  --   lazy = true,
  -- },
  {
    "sonph/onehalf",
    "onehalf",
  },
  {
    "junegunn/seoul256.vim",
    "seoul256",
  },
  {
    "lifepillar/vim-solarized8",
    "solarized8",
    url = "https://codeberg.org/lifepillar/vim-solarized8",
  },
  {
    "jacoborus/tender.vim",
    "tender",
  },
}

local now = uv.clock_gettime("realtime") --[[@as {sec:integer,nsec:integer} ]]
local index = math.floor(math.fmod(now.nsec, #all_colors)) + 1
local color = all_colors[index]
local color_spec = {
  color[1],
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd("color " .. color[2])
  end,
}
if type(color.url) == "string" then
  color_spec.url = color.url
end
if type(color.name) == "string" then
  color_spec.name = color.name
end
if type(color.dependencies) == "string" or type(color.dependencies) == "table" then
  color_spec.dependencies = color.dependencies
end

return color_spec
