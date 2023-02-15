local glance = require("glance")
local actions = glance.actions

glance.setup({
  border = {
    enable = true,
  },
  detached = function(winid)
    return vim.api.nvim_win_get_width(winid) < 80
  end,
  mappings = {
    list = {
      -- quit
      ["Q"] = false,
    },
    preview = {
      -- quit
      ["q"] = actions.close,
      ["Q"] = false,
      -- navigation
      ["<Tab>"] = false,
      ["<S-Tab>"] = false,
    },
  },
})
