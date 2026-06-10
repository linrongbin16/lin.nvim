local constants = require("builtin.constants")

local basic_actions = {
  ["enter"] = require("fzf-lua").actions.file_edit,
  ["ctrl-s"] = false,
  ["ctrl-v"] = false,
  ["ctrl-t"] = false,
}

local toggle_actions = vim.tbl_deep_extend("force", basic_actions, {
  ["ctrl-i"] = require("fzf-lua").actions.toggle_ignore,
  ["ctrl-h"] = require("fzf-lua").actions.toggle_hidden,
})

local grep_actions = vim.tbl_deep_extend("force", toggle_actions, {
  ["ctrl-g"] = false,
})

local git_grep_actions = vim.tbl_deep_extend("force", basic_actions, {
  ["ctrl-g"] = false,
})

require("fzf-lua").setup({
  -- { "fzf-native" },
  { "default" },
  winopts = {
    height = constants.layout.window.scale,
    width = constants.layout.window.scale,
    border = constants.window.border,
    treesitter = {
      enabled = false,
    },
    preview = {
      border = constants.window.border,
    },
  },
  fzf_colors = {
    true,
    ["fg+"] = { "fg", "Visual" },
    ["bg+"] = { "bg", "Visual" },
  },
  keymap = {
    builtin = {
      ["<C-E>"] = "toggle",
      ["<C-L>"] = "toggle-preview",
      ["<C-F>"] = "preview-half-page-down",
      ["<C-B>"] = "preview-half-page-up",
    },
    fzf = {
      ["ctrl-e"] = "toggle",
      ["ctrl-l"] = "toggle-preview",
      ["ctrl-f"] = "preview-half-page-down",
      ["ctrl-b"] = "preview-half-page-up",
    },
  },
  actions = {
    files = basic_actions,
  },
  files = {
    cwd_prompt = false,
    actions = toggle_actions,
  },
  git = {
    files = {
      cwd_prompt = false,
      actions = basic_actions,
    },
  },
  grep = {
    prompt = "Live Grep> ",
    rg_glob_fn = function(query, opts)
      local regex, flags = query:match("^(.-)%s%-%-(.*)$")
      return (regex or query), flags
    end,
    actions = grep_actions,
  },
  buffers = {
    prompt = "Buffers> ",
    actions = basic_actions,
  },
  lsp = {
    jump1 = false,
  },
})
