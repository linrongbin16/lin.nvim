local constants = require("builtin.constants")

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
    },
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
})
