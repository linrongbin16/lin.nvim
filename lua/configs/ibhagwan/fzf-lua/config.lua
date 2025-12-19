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
  files = {
    cwd_prompt = false,
    actions = {
      ["ctrl-r"] = { require("fzf-lua").actions.toggle_ignore },
    },
  },
  grep = {
    prompt = "Live Grep> ",
    actions = {
      ["ctrl-r"] = { require("fzf-lua").actions.toggle_ignore },
    },
    rg_glob_fn = function(query, opts)
      local regex, flags = query:match("^(.-)%s%-%-(.*)$")
      return (regex or query), flags
    end,
  },
  buffers = {
    prompt = "Buffers> ",
  },
})
