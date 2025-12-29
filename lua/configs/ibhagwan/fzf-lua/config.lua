local constants = require("builtin.constants")

local basic_actions = {
  ["enter"] = require("fzf-lua").actions.file_edit,
  ["ctrl-s"] = false,
  ["ctrl-v"] = false,
  ["ctrl-t"] = false,
}

local toggle_ignore_actions = vim.tbl_deep_extend("force", basic_actions, {
  ["ctrl-i"] = require("fzf-lua").actions.toggle_ignore,
})

local fzf_keymaps = {
  ["ctrl-g"] = "toggle",
  ["ctrl-p"] = "toggle-preview",
}

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
    fzf = fzf_keymaps,
  },
  actions = {
    files = toggle_ignore_actions,
    git = {
      files = basic_actions,
    },
    grep = toggle_ignore_actions,
    buffers = basic_actions,
  },
  files = {
    cwd_prompt = false,
    hidden = true,
  },
  git = {
    files = {
      cwd_prompt = false,
    },
  },
  grep = {
    prompt = "Live Grep> ",
    hidden = true,
    rg_glob_fn = function(query, opts)
      local regex, flags = query:match("^(.-)%s%-%-(.*)$")
      return (regex or query), flags
    end,
  },
  buffers = {
    prompt = "Buffers> ",
  },
})
