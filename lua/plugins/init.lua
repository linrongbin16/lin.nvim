-- ---- Plugins ----

local lua_keys = require("builtin.utils.plugin").lua_keys
local lua_init = require("builtin.utils.plugin").lua_init
local lua_config = require("builtin.utils.plugin").lua_config
local vim_init = require("builtin.utils.plugin").vim_init
local vim_config = require("builtin.utils.plugin").vim_config

local VeryLazy = "VeryLazy"
local BufEnter = "BufEnter"
local BufWritePre = "BufWritePre"
local BufWritePost = "BufWritePost"
local CmdlineEnter = "CmdlineEnter"
local VimEnter = "VimEnter"
local InsertEnter = "InsertEnter"
local UIEnter = "UIEnter"

local M = {
  -- ---- INFRASTRUCTURE ----

  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "linrongbin16/commons.nvim",
    dev = true,
    lazy = true,
  },
  {
    "linrongbin16/colorbox.nvim",
    dev = true,
    priority = 1000,
    config = lua_config("linrongbin16/colorbox.nvim"),
    build = function()
      require("colorbox").update()
    end,
  },

  -- ---- HIGHLIGHT ----

  {
    "nvim-treesitter/nvim-treesitter",
    event = { VeryLazy },
    cmd = {
      "TSInstall",
      "TSInstallSync",
      "TSInstallInfo",
      "TSUpdate",
      "TSUpdateSync",
      "TSUninstall",
    },
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    config = lua_config("nvim-treesitter/nvim-treesitter"),
  },
  {
    "RRethy/vim-illuminate",
    event = { VeryLazy },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = lua_config("RRethy/vim-illuminate"),
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = { VeryLazy },
    config = lua_config("NvChad/nvim-colorizer.lua"),
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { VeryLazy },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = lua_config("nvim-treesitter/nvim-treesitter-context"),
  },
  {
    "andymass/vim-matchup",
    event = { VeryLazy },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = lua_init("andymass/vim-matchup"),
  },
  -- Range/substitude
  {
    "markonm/traces.vim",
    event = { CmdlineEnter },
  },
  -- Mark word
  {
    "inkarkat/vim-ingo-library",
    lazy = true,
  },
  {
    "inkarkat/vim-mark",
    event = { CmdlineEnter },
    dependencies = { "inkarkat/vim-ingo-library" },
    init = lua_init("inkarkat/vim-mark"),
    keys = lua_keys("inkarkat/vim-mark"),
  },

  -- ---- UI ----

  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    event = { VeryLazy },
    dependencies = { "MunifTanjim/nui.nvim" },
    version = "*",
    config = lua_config("nvim-neo-tree/neo-tree.nvim"),
    keys = lua_keys("nvim-neo-tree/neo-tree.nvim"),
  },
  -- Tabline
  {
    "moll/vim-bbye",
    cmd = { "Bdelete", "Bwipeout" },
    keys = lua_keys("moll/vim-bbye"),
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = { VeryLazy },
    dependencies = { "moll/vim-bbye" },
    config = lua_config("akinsho/bufferline.nvim"),
    keys = lua_keys("akinsho/bufferline.nvim"),
  },
  -- Indentline
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { VeryLazy },
    config = lua_config("lukas-reineke/indent-blankline.nvim"),
  },
  -- Git
  {
    "airblade/vim-gitgutter",
    event = { VeryLazy },
    init = lua_init("airblade/vim-gitgutter"),
    keys = lua_keys("airblade/vim-gitgutter"),
  },
  -- Statusline
  {
    "itchyny/vim-gitbranch",
    event = { VeryLazy },
  },
  {
    "linrongbin16/lsp-progress.nvim",
    dev = true,
    lazy = true,
    config = lua_config("linrongbin16/lsp-progress.nvim"),
  },
  {
    "rebelot/heirline.nvim",
    event = { VeryLazy },
    dependencies = {
      "linrongbin16/lsp-progress.nvim",
      dev = true,
    },
    config = lua_config("rebelot/heirline.nvim"),
  },
  -- Winbar
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = lua_init("SmiteshP/nvim-navic"),
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    event = { VeryLazy },
    dependencies = { "SmiteshP/nvim-navic" },
    config = lua_config("utilyre/barbecue.nvim"),
  },
  -- UI improvement
  {
    "stevearc/dressing.nvim",
    event = { VeryLazy },
    dependencies = { "junegunn/fzf" },
    config = lua_config("stevearc/dressing.nvim"),
  },
  {
    "stevearc/stickybuf.nvim",
    event = { VeryLazy },
    config = lua_config("stevearc/stickybuf.nvim"),
  },

  -- ---- SEARCH ----

  -- Fuzzy search
  {
    "junegunn/fzf",
    event = { CmdlineEnter },
    build = function()
      vim.fn["fzf#install"]()
    end,
  },
  {
    "linrongbin16/fzfx.nvim",
    dev = true,
    event = { CmdlineEnter },
    cmd = {
      "FzfxLspDefinitions",
      "FzfxLspTypeDefinitions",
      "FzfxLspReferences",
      "FzfxLspImplementations",
      "FzfxLspIncomingCalls",
      "FzfxLspOutgoingCalls",
    },
    dependencies = { "junegunn/fzf" },
    config = lua_config("linrongbin16/fzfx.nvim"),
    keys = lua_keys("linrongbin16/fzfx.nvim"),
  },
  -- Search and replace
  {
    "nvim-pack/nvim-spectre",
    cmd = { "Spectre" },
    config = lua_config("nvim-pack/nvim-spectre"),
  },

  -- ---- PROJECT ----

  -- Project/local configuration
  {
    "folke/neoconf.nvim",
    event = { VeryLazy },
    cmd = { "Neoconf" },
    config = lua_config("folke/neoconf.nvim"),
  },

  -- ---- LSP ----

  -- Lsp configuration
  {
    "folke/neodev.nvim",
    ft = { "lua" },
    event = { VeryLazy },
    dependencies = { "folke/neoconf.nvim" }, -- neoconf must be setup before neodev
    config = lua_config("folke/neodev.nvim"),
  },
  {
    "neovim/nvim-lspconfig",
    event = { VeryLazy },
    dependencies = { "folke/neoconf.nvim", "folke/neodev.nvim" }, -- neoconf, neodev must be setup before nvim-lspconfig
    config = lua_config("neovim/nvim-lspconfig"),
  },
  -- Lsp server management
  {
    "williamboman/mason.nvim",
    event = { VeryLazy },
    cmd = {
      "Mason",
      "MasonUpdate",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
    dependencies = { "neovim/nvim-lspconfig" },
    build = ":MasonUpdate",
    config = lua_config("williamboman/mason.nvim"),
    keys = lua_keys("williamboman/mason.nvim"),
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { VeryLazy },
    cmd = {
      "LspInstall",
      "LspUninstall",
    },
    dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
    config = lua_config("williamboman/mason-lspconfig.nvim"),
  },
  {
    "stevearc/conform.nvim",
    event = { BufWritePre, BufWritePost },
    cmd = { "ConformInfo" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = lua_config("stevearc/conform.nvim"),
    keys = lua_keys("stevearc/conform.nvim"),
  },
  {
    "nvimtools/none-ls.nvim",
    event = { VeryLazy },
    cmd = {
      "NullLsInfo",
      "NullLsLog",
    },
    dependencies = { "neovim/nvim-lspconfig" },
    config = lua_config("jose-elias-alvarez/null-ls.nvim"),
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { VeryLazy },
    cmd = {
      "NullLsInstall",
      "NoneLsInstall",
      "NullLsUninstall",
      "NoneLsUninstall",
    },
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = lua_config("jay-babu/mason-null-ls.nvim"),
  },
  -- {
  --     "mfussenegger/nvim-lint",
  --     event = { VeryLazy, BufWritePost },
  --     dependencies = {
  --         "neovim/nvim-lspconfig",
  --         "williamboman/mason.nvim",
  --         "williamboman/mason-lspconfig.nvim",
  --     },
  --     config = lua_config("mfussenegger/nvim-lint"),
  -- },
  -- Lsp server GC
  -- {
  --   "hinell/lsp-timeout.nvim",
  --   event = { VeryLazy },
  --   dependencies = { "neovim/nvim-lspconfig" },
  --   init = lua_init("hinell/lsp-timeout.nvim"),
  -- },
  {
    "Zeioth/garbage-day.nvim",
    event = { VeryLazy },
    dependencies = { "neovim/nvim-lspconfig" },
    init = lua_init("Zeioth/garbage-day.nvim"),
  },
  -- Symbol navigation
  {
    "DNLHC/glance.nvim",
    cmd = { "Glance" },
    config = lua_config("DNLHC/glance.nvim"),
  },

  -- ---- AUTO-COMPLETE ----
  {
    "onsails/lspkind.nvim",
    lazy = true,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    event = { InsertEnter },
  },
  {
    "hrsh7th/cmp-buffer",
    event = { InsertEnter },
  },
  {
    "FelipeLema/cmp-async-path",
    event = { InsertEnter, CmdlineEnter },
  },
  {
    "rafamadriz/friendly-snippets",
    lazy = true,
  },
  {
    "L3MON4D3/LuaSnip",
    event = { InsertEnter },
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "v2.*",
    submodules = false,
  },
  {
    "saadparwaiz1/cmp_luasnip",
    event = { InsertEnter },
    dependencies = { "L3MON4D3/LuaSnip" },
  },
  {
    "hrsh7th/cmp-cmdline",
    event = { CmdlineEnter },
  },
  {
    "hrsh7th/nvim-cmp",
    event = { InsertEnter, CmdlineEnter },
    dependencies = {
      "neovim/nvim-lspconfig",
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "FelipeLema/cmp-async-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-cmdline",
    },
    config = lua_config("hrsh7th/nvim-cmp"),
  },

  -- ---- SPECIFIC LANGUAGE SUPPORT ----

  -- Markdown
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    cmd = {
      "MarkdownPreviewToggle",
      "MarkdownPreview",
      "MarkdownPreviewStop",
    },
    ft = { "markdown" },
    init = lua_init("iamcco/markdown-preview.nvim"),
    keys = lua_keys("iamcco/markdown-preview.nvim"),
  },

  -- ---- KEY BINDING ----

  -- Key mappings
  {
    "folke/which-key.nvim",
    cmd = { "WhichKey" },
    config = lua_config("folke/which-key.nvim"),
    keys = lua_keys("folke/which-key.nvim"),
  },

  -- ---- GIT INTEGRATION ----

  -- Blame
  {
    "f-person/git-blame.nvim",
    cmd = {
      "GitBlameToggle",
      "GitBlameEnable",
      "GitBlameDisable",
    },
    config = lua_config("f-person/git-blame.nvim"),
    keys = lua_keys("f-person/git-blame.nvim"),
  },
  -- Permlink
  {
    "linrongbin16/gitlinker.nvim",
    dev = true,
    cmd = { "GitLink" },
    config = lua_config("linrongbin16/gitlinker.nvim"),
    keys = lua_keys("linrongbin16/gitlinker.nvim"),
  },

  -- ---- ENHANCEMENT ----

  -- Auto pair/close
  {
    "windwp/nvim-autopairs",
    event = { VeryLazy, InsertEnter },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = lua_config("windwp/nvim-autopairs"),
  },
  {
    "windwp/nvim-ts-autotag",
    event = { VeryLazy, InsertEnter },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = lua_config("windwp/nvim-ts-autotag"),
  },
  -- Repeat
  {
    "tpope/vim-repeat",
    event = { VeryLazy },
  },
  -- Comment
  {
    "numToStr/Comment.nvim",
    event = { VeryLazy },
    config = lua_config("numToStr/Comment.nvim"),
  },
  -- Cursor motion
  {
    "smoka7/hop.nvim",
    version = "*",
    config = lua_config("smoka7/hop.nvim"),
    keys = lua_keys("smoka7/hop.nvim"),
  },
  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = { VeryLazy },
    config = lua_config("kylechui/nvim-surround"),
  },
  -- Structure outlines
  {
    "stevearc/aerial.nvim",
    cmd = {
      "AerialToggle",
      "AerialOpen",
      "AerialOpenAll",
      "AerialClose",
      "AerialInfo",
    },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = lua_keys("stevearc/aerial.nvim"),
    config = lua_config("stevearc/aerial.nvim"),
  },
  -- Open Url
  {
    "chrishrb/gx.nvim",
    cmd = { "Browse" },
    config = lua_config("chrishrb/gx.nvim"),
    init = lua_init("chrishrb/gx.nvim"),
    keys = lua_keys("chrishrb/gx.nvim"),
    submodules = false,
  },
}

return M
