-- ---- Plugins ----

local plugin = require("api.plugin")

local VeryLazy = "VeryLazy"
local BufEnter = "BufEnter"
local BufWritePre = "BufWritePre"
local BufWritePost = "BufWritePost"
local BufReadPre = "BufReadPre"
local BufNewFile = "BufNewFile"
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
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  {
    "linrongbin16/commons.nvim",
    lazy = true,
  },
  {
    "linrongbin16/colorbox.nvim",
    lazy = false,
    priority = 1000,
    dependencies = "rktjmp/lush.nvim",
    config = plugin.config("linrongbin16/colorbox.nvim"),
  },

  -- ---- HIGHLIGHT ----

  {
    "itchyny/vim-cursorword",
    event = { VeryLazy },
    init = plugin.init("itchyny/vim-cursorword"),
  },
  {
    "brenoprata10/nvim-highlight-colors",
    event = { VeryLazy },
    config = plugin.config("brenoprata10/nvim-highlight-colors"),
  },
  {
    "andymass/vim-matchup",
    event = { VeryLazy },
    init = plugin.init("andymass/vim-matchup"),
  },
  {
    "markonm/traces.vim",
    event = { CmdlineEnter },
  },
  {
    "saghen/blink.indent",
    event = { VeryLazy, BufReadPre, BufNewFile },
    version = "*",
    config = plugin.config("saghen/blink.indent"),
  },

  -- ---- MARKDOWN PREVIEW ----

  {
    "wallpants/github-preview.nvim",
    cmd = { "GithubPreviewToggle" },
    keys = plugin.keys("wallpants/github-preview.nvim"),
    config = plugin.config("wallpants/github-preview.nvim"),
  },

  -- ---- UI ----

  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   event = { VeryLazy },
  --   dependencies = { "MunifTanjim/nui.nvim", "folke/snacks.nvim", "neovim/nvim-lspconfig" },
  --   version = "*",
  --   config = plugin.config("nvim-neo-tree/neo-tree.nvim"),
  --   keys = plugin.keys("nvim-neo-tree/neo-tree.nvim"),
  -- },
  {
    "stevearc/oil.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = plugin.config("stevearc/oil.nvim"),
    keys = plugin.keys("stevearc/oil.nvim"),
  },
  {
    "romgrk/barbar.nvim",
    event = { VeryLazy },
    init = plugin.init("romgrk/barbar.nvim"),
    config = plugin.config("romgrk/barbar.nvim"),
    keys = plugin.keys("romgrk/barbar.nvim"),
  },
  -- Statusline
  {
    "linrongbin16/lsp-progress.nvim",
    config = plugin.config("linrongbin16/lsp-progress.nvim"),
  },
  {
    "nvim-lualine/lualine.nvim",
    event = { VeryLazy },
    dependencies = { "linrongbin16/lsp-progress.nvim", "lewis6991/gitsigns.nvim" },
    config = plugin.config("nvim-lualine/lualine.nvim"),
  },
  {
    "stevearc/stickybuf.nvim",
    event = { VeryLazy },
    config = plugin.config("stevearc/stickybuf.nvim"),
  },

  -- ---- SEARCH ----

  -- Fuzzy search
  {
    "ibhagwan/fzf-lua",
    event = { "CmdlineEnter" },
    config = plugin.config("ibhagwan/fzf-lua"),
    keys = plugin.keys("ibhagwan/fzf-lua"),
  },

  -- ---- LSP ----

  {
    "neovim/nvim-lspconfig",
    event = { VeryLazy, BufReadPre, BufNewFile },
  },
  {
    "mason-org/mason.nvim",
    event = { VeryLazy, BufReadPre, BufNewFile },
    cmd = {
      "Mason",
      "MasonUpdate",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
    build = ":MasonUpdate",
    dependencies = "neovim/nvim-lspconfig",
    config = plugin.config("mason-org/mason.nvim"),
    keys = plugin.keys("mason-org/mason.nvim"),
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { VeryLazy, BufReadPre, BufNewFile },
    cmd = {
      "LspInstall",
      "LspUninstall",
    },
    dependencies = { "neovim/nvim-lspconfig", "mason-org/mason.nvim" },
    config = plugin.config("mason-org/mason-lspconfig.nvim"),
  },
  {
    "nvimtools/none-ls.nvim",
    event = { VeryLazy, BufReadPre, BufNewFile },
    cmd = { "NullLsInfo", "NullLsLog" },
    dependencies = "neovim/nvim-lspconfig",
    config = plugin.config("nvimtools/none-ls.nvim"),
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { VeryLazy, BufReadPre, BufNewFile },
    cmd = {
      "NullLsInstall",
      "NoneLsInstall",
      "NullLsUninstall",
      "NoneLsUninstall",
    },
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = plugin.config("jay-babu/mason-null-ls.nvim"),
  },

  -- ---- AUTO-COMPLETE ----

  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    dependencies = "rafamadriz/friendly-snippets",
    version = "v2.*",
    submodules = false,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    dependencies = "Bilal2453/luvit-meta",
    config = plugin.config("folke/lazydev.nvim"),
  },
  {
    "saghen/blink.cmp",
    event = { VeryLazy, CmdlineEnter, InsertEnter },
    dependencies = {
      "saghen/blink.lib",
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
      "nvim-tree/nvim-web-devicons",
      "onsails/lspkind.nvim",
      "folke/lazydev.nvim",
    },
    config = plugin.config("saghen/blink.cmp"),
    build = function()
      require("blink.cmp").build():pwait()
    end,
  },

  -- ---- CODE-FORMATTER ----

  {
    "stevearc/conform.nvim",
    event = { BufWritePre, BufWritePost },
    cmd = { "ConformInfo" },
    dependencies = "neovim/nvim-lspconfig",
    config = plugin.config("stevearc/conform.nvim"),
    keys = plugin.keys("stevearc/conform.nvim"),
  },

  -- ---- CODE-ACTION ----

  {
    "rachartier/tiny-code-action.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
    event = "LspAttach",
    config = plugin.config("rachartier/tiny-code-action.nvim"),
    keys = plugin.keys("rachartier/tiny-code-action.nvim"),
  },

  -- ---- KEY BINDING ----

  -- Key mappings
  {
    "folke/which-key.nvim",
    event = { VeryLazy, CmdlineEnter, InsertEnter },
    cmd = { "WhichKey" },
    config = plugin.config("folke/which-key.nvim"),
    keys = plugin.keys("folke/which-key.nvim"),
  },

  -- ---- GIT INTEGRATION ----

  -- Diff
  {
    "lewis6991/gitsigns.nvim",
    event = { VeryLazy },
    cmd = { "Gitsigns" },
    config = plugin.config("lewis6991/gitsigns.nvim"),
    keys = plugin.keys("lewis6991/gitsigns.nvim"),
  },
  -- Permlink
  {
    "linrongbin16/gitlinker.nvim",
    cmd = { "GitLink" },
    config = plugin.config("linrongbin16/gitlinker.nvim"),
    keys = plugin.keys("linrongbin16/gitlinker.nvim"),
  },

  -- ---- ENHANCEMENT ----

  -- Cursor motion
  {
    "smoka7/hop.nvim",
    event = { VeryLazy, BufReadPre, BufNewFile },
    version = "*",
    config = plugin.config("smoka7/hop.nvim"),
    keys = plugin.keys("smoka7/hop.nvim"),
  },
  {
    "andyg/leap.nvim",
    url = "https://codeberg.org/andyg/leap.nvim",
    -- url = "https://git.disroot.org/andyg/leap.nvim",
    dependencies = "tpope/vim-repeat",
    lazy = false,
    keys = plugin.keys("andyg/leap.nvim"),
  },
  -- Comment
  {
    "tomtom/tcomment_vim",
    event = { BufReadPre, BufNewFile, VeryLazy },
  },
  -- Pairs
  {
    "cohama/lexima.vim",
    event = { BufReadPre, BufNewFile, VeryLazy },
    init = plugin.init("cohama/lexima.vim"),
  },
  -- Repeat
  {
    "tpope/vim-repeat",
  },
  -- Surround
  {
    "tpope/vim-surround",
    event = { BufReadPre, BufNewFile, VeryLazy },
    dependencies = "tpope/vim-repeat",
  },
  -- Structure outlines
  {
    "hedyhli/outline.nvim",
    cmd = {
      "Outline",
      "OutlineOpen",
      "OutlineStatus",
      "OutlineFollow",
      "OutlineRefresh",
    },
    dependencies = "neovim/nvim-lspconfig",
    keys = plugin.keys("hedyhli/outline.nvim"),
    config = plugin.config("hedyhli/outline.nvim"),
  },
  -- Open Url
  {
    "chrishrb/gx.nvim",
    cmd = { "Browse" },
    init = plugin.init("chrishrb/gx.nvim"),
    config = plugin.config("chrishrb/gx.nvim"),
    keys = plugin.keys("chrishrb/gx.nvim"),
    submodules = false,
  },
  -- vim.ui.select
  {
    "folke/snacks.nvim",
    lazy = false,
    config = plugin.config("folke/snacks.nvim"),
    keys = plugin.keys("folke/snacks.nvim"),
  },
  -- Split window width
  {
    "mrjones2014/smart-splits.nvim",
    event = { UIEnter },
    config = plugin.config("mrjones2014/smart-splits.nvim"),
    keys = plugin.keys("mrjones2014/smart-splits.nvim"),
  },
}

return M
