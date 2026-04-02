-- ---- Colorschemes ----

local uv = vim.uv or vim.loop

-- Collect from:
--
-- Neovim Colors: <https://www.trackawesomelist.com/rockerBOO/awesome-neovim/readme/>
-- Vim Colors: <https://github.com/rafi/awesome-vim-colorschemes>
-- GitHub neovim-colorscheme topic: <https://github.com/topics/neovim-colorscheme>
-- GitHub vim-colorscheme topic: <https://github.com/topics/vim-colorscheme>
--
-- Only github stars >= 800 are picked.

--- @param colorname string
--- @return function():nil
local function cfg(colorname)
  local function impl()
    vim.cmd("color " .. colorname)
  end
  return impl
end

local all_colors = {
  -- ---- NEOVIM COLORS ----
  {
    "tomasiser/vim-code-dark",
    lazy = true,
    config = cfg("codedark"),
  },
  {
    "Mofiqul/vscode.nvim",
    lazy = true,
    config = cfg("vscode"),
  },
  {
    "marko-cerovac/material.nvim",
    lazy = true,
    config = cfg("material"),
  },
  {
    "bluz71/vim-nightfly-colors",
    lazy = true,
    config = cfg("nightly"),
  },
  {
    "bluz71/vim-moonfly-colors",
    lazy = true,
    config = cfg("moonfly"),
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    config = cfg("tokyonight"),
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    config = cfg("kanagawa"),
  },
  {
    "kepano/flexoki",
    lazy = true,
    config = cfg("flexoki"),
  },
  {
    "vague-theme/vague.nvim",
    lazy = true,
    config = cfg("vague"),
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    config = cfg("onedark"),
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    config = cfg("solarized-osaka"),
  },
  {
    "sainnhe/sonokai",
    lazy = true,
    config = cfg("sonokai"),
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = true,
    config = cfg("oxocarbon"),
  },
  {
    "mhartington/oceanic-next",
    lazy = true,
    config = cfg("OceanicNext"),
  },
  {
    "sainnhe/edge",
    lazy = true,
    config = cfg("edge"),
  },
  {
    "savq/melange-nvim",
    lazy = true,
    config = cfg("melange"),
  },
  {
    "fenetikm/falcon",
    lazy = true,
    config = cfg("falcon"),
  },
  {
    "AlexvZyl/nordic.nvim",
    lazy = true,
    config = cfg("nordic"),
  },
  {
    "shaunsingh/nord.nvim",
    lazy = true,
    config = cfg("nord"),
  },
  -- {
  --   -- replaced by "olimorris/onedarkpro.nvim"
  --   "navarasu/onedark.nvim",
  --   lazy = true,
  --   config = cfg("onedark"),
  -- },
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    config = cfg("gruvbox-material"),
  },
  {
    "sainnhe/everforest",
    lazy = true,
    config = cfg("everforest"),
  },
  {
    "dracula/vim",
    name = "dracula",
    lazy = true,
    config = cfg("dracula"),
  },
  {
    "projekt0n/github-nvim-theme",
    lazy = true,
    config = cfg("github_dark"),
  },
  {
    "rose-pine/neovim",
    lazy = true,
    config = cfg("rose-pine"),
  },
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim",
    lazy = true,
    config = cfg("zenbones"),
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    config = cfg("catppuccin"),
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    config = cfg("nightfox"),
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    config = cfg("cyberdream"),
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    config = cfg("gruvbox"),
  },

  -- ---- VIM COLORS ----
  {
    "ayu-theme/ayu-vim",
    lazy = true,
    config = cfg("ayu"),
  },
  {
    "romainl/Apprentice",
    lazy = true,
    config = cfg("apprentice"),
  },
  {
    "ajmwagar/vim-deus",
    lazy = true,
    config = cfg("deus"),
  },
  {
    "whatyouhide/vim-gotham",
    lazy = true,
    config = cfg("gotham"),
  },
  -- {
  --   -- gruvbox
  --   -- replaced by "ellisonleao/gruvbox.nvim"
  --   "morhetz/gruvbox",
  --   lazy = true,
  -- },
  {
    "cocopon/iceberg.vim",
    lazy = true,
    config = cfg("iceberg"),
  },
  {
    "NLKNguyen/papercolor-theme",
    lazy = true,
    config = cfg("PaperColor"),
  },
  {
    "nanotech/jellybeans.vim",
    lazy = true,
    config = cfg("jellybeans"),
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
    lazy = true,
    config = cfg("one"),
  },
  -- {
  --   -- onedark
  --   -- replaced by "navarasu/onedark.nvim"
  --   "joshdick/onedark.vim",
  --   lazy = true,
  -- },
  {
    "junegunn/seoul256.vim",
    lazy = true,
    config = cfg("seoul256"),
  },
  {
    "lifepillar/vim-solarized8",
    url = "https://codeberg.org/lifepillar/vim-solarized8",
    lazy = true,
    config = cfg("solarized8"),
  },
  {
    "jacoborus/tender.vim",
    lazy = true,
    config = cfg("tender"),
  },
}

local now = uv.clock_gettime("realtime") --[[@as {sec:integer,nsec:integer} ]]
local index = math.floor(math.fmod(now.nsec, #all_colors)) + 1
all_colors[index].lazy = false
all_colors[index].priority = 1000

return all_colors
