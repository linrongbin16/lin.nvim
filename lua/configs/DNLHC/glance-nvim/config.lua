local glance = require("glance")
local actions = glance.actions
local layout = require("builtin.utils.layout")

glance.setup({
  height = layout.editor.height(0.99, 7, 18),
  mappings = {
    list = {
      -- open
      ["<C-w>s"] = actions.jump_split,
      ["s"] = false,
      ["<C-w>v"] = actions.jump_vsplit,
      ["v"] = false,
      ["<C-w>t"] = actions.jump_tab,
      ["t"] = false,

      -- disable go to preview window
      ["<Leader>l"] = false,
    },
    preview = {
      -- disable navigation
      ["<Tab>"] = false,
      ["<S-Tab>"] = false,

      -- disable go to list window
      ["<Leader>l"] = false,
    },
  },
})
