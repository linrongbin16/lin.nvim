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
    "linrongbin16/commons.nvim",
    dev = true,
    lazy = true,
  },
  -- Colorschemes
  {
    "linrongbin16/colorbox.nvim",
    dev = true,
    priority = 1000,
    lazy = false,
    config = lua_config("linrongbin16/colorbox.nvim"),
    build = function()
      require("colorbox").update()
    end,
  },
  -- UI improvements
  {
    "folke/snacks.nvim",
    lazy = false,
    config = lua_config("folke/snacks.nvim"),
  },

  -- ---- HIGHLIGHT ----

  {
    "itchyny/vim-cursorword",
    event = { VeryLazy },
    init = lua_init("itchyny/vim-cursorword"),
  },
  {
    "brenoprata10/nvim-highlight-colors",
    event = { VeryLazy },
    config = lua_config("brenoprata10/nvim-highlight-colors"),
  },
  {
    "andymass/vim-matchup",
    event = { VeryLazy },
    init = lua_init("andymass/vim-matchup"),
  },
  -- Range/substitude
  {
    "markonm/traces.vim",
    event = { CmdlineEnter },
  },

  -- ---- Specific Support ----

  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = { "markdown" },
    init = lua_init("iamcco/markdown-preview.nvim"),
    keys = lua_keys("iamcco/markdown-preview.nvim"),
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
  {
    "moll/vim-bbye",
    keys = lua_keys("moll/vim-bbye"),
  },
  {
    "akinsho/bufferline.nvim",
    event = { VeryLazy },
    dependencies = { "moll/vim-bbye" },
    config = lua_config("akinsho/bufferline.nvim"),
    keys = lua_keys("akinsho/bufferline.nvim"),
  },
  -- Git
  {
    "airblade/vim-gitgutter",
    event = { VeryLazy },
    init = lua_init("airblade/vim-gitgutter"),
    keys = lua_keys("airblade/vim-gitgutter"),
  },
  {
    "kdheepak/lazygit.nvim",
    init = lua_init("kdheepak/lazygit.nvim"),
    keys = lua_keys("kdheepak/lazygit.nvim"),
  },
  -- Statusline
  {
    "linrongbin16/lsp-progress.nvim",
    dev = true,
    lazy = true,
    config = lua_config("linrongbin16/lsp-progress.nvim"),
  },
  {
    "nvim-lualine/lualine.nvim",
    event = { VeryLazy },
    dependencies = {
      "linrongbin16/lsp-progress.nvim",
      dev = true,
    },
    config = lua_config("nvim-lualine/lualine.nvim"),
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
    event = { "CmdlineEnter" },
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

  -- ---- LSP ----

  {
    "neovim/nvim-lspconfig",
    event = { VeryLazy },
    config = lua_config("neovim/nvim-lspconfig"),
  },
  -- Lsp server management
  {
    "mason-org/mason.nvim",
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
    config = lua_config("mason-org/mason.nvim"),
    keys = lua_keys("mason-org/mason.nvim"),
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { VeryLazy },
    cmd = {
      "LspInstall",
      "LspUninstall",
    },
    dependencies = { "neovim/nvim-lspconfig", "mason-org/mason.nvim" },
    config = lua_config("mason-org/mason-lspconfig.nvim"),
  },
  {
    "stevearc/conform.nvim",
    event = { BufWritePre, BufWritePost },
    cmd = { "ConformInfo" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
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
    config = lua_config("nvimtools/none-ls.nvim"),
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
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = lua_config("jay-babu/mason-null-ls.nvim"),
  },

  -- ---- AUTO-COMPLETE ----
  {
    "rafamadriz/friendly-snippets",
    lazy = true,
  },
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "v2.*",
    submodules = false,
  },
  {
    "saghen/blink.cmp",
    event = { VeryLazy, CmdlineEnter, InsertEnter },
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
    },
    version = "v0.*",
    config = lua_config("saghen/blink.cmp"),
  },

  -- ---- KEY BINDING ----

  -- Key mappings
  {
    "folke/which-key.nvim",
    event = { VeryLazy, CmdlineEnter, InsertEnter },
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

  -- Cursor motion
  {
    "smoka7/hop.nvim",
    event = { VeryLazy, BufReadPre, BufNewFile },
    version = "*",
    config = lua_config("smoka7/hop.nvim"),
    keys = lua_keys("smoka7/hop.nvim"),
  },
  {
    "folke/flash.nvim",
    event = { VeryLazy, BufReadPre, BufNewFile },
    config = lua_config("folke/flash.nvim"),
    keys = lua_keys("folke/flash.nvim"),
  },
  -- Comment
  {
    "tomtom/tcomment_vim",
    event = { BufReadPre, BufNewFile, VeryLazy },
  },
  -- Auto-pairs
  {
    "cohama/lexima.vim",
    event = { VeryLazy, InsertEnter },
    init = lua_init("cohama/lexima.vim"),
  },
  -- Repeat
  {
    "tpope/vim-repeat",
    event = { BufReadPre, BufNewFile, VeryLazy },
  },
  -- Surround
  {
    "tpope/vim-surround",
    event = { BufReadPre, BufNewFile, VeryLazy },
    dependencies = { "tpope/vim-repeat" },
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
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    keys = lua_keys("hedyhli/outline.nvim"),
    config = lua_config("hedyhli/outline.nvim"),
  },
  -- Open Url
  {
    "chrishrb/gx.nvim",
    cmd = { "Browse" },
    init = lua_init("chrishrb/gx.nvim"),
    config = lua_config("chrishrb/gx.nvim"),
    keys = lua_keys("chrishrb/gx.nvim"),
    submodules = false,
  },
}

return M
