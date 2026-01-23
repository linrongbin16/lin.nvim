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
  { "fzf-native" },
  winopts = {
    height = constants.layout.window.scale,
    width = constants.layout.window.scale,
    -- row = 0.35, -- window row position (0=top, 1=bottom)
    -- col = 0.50, -- window col position (0=left, 1=right)
    border = constants.window.border,
    treesitter = {
      enabled = false,
    },
    preview = {
      default = "bat",
      border = constants.window.border,
    },
  },
  keymap = {
    fzf = {
      ["ctrl-e"] = "toggle",
      ["ctrl-l"] = "toggle-preview",
      ["ctrl-f"] = "preview-page-down",
      ["ctrl-b"] = "preview-page-up",
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
