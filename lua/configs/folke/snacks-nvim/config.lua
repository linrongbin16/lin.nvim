local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")

require("snacks").setup({
  styles = {
    input = {
      border = constants.window.border,
      width = constants.layout.input.scale,
      height = 1,
      relative = "cursor",
      row = 1,
      col = 0,
      keys = {
        i_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "i", expr = true },
      },
    },
    -- lazygit = {
    --   border = constants.window.border,
    --   -- height = constants.layout.window.scale,
    --   height = function()
    --     return layout.editor.height(constants.layout.window.scale, 1)
    --   end,
    --   width = function()
    --     return layout.editor.width(constants.layout.window.scale, 1)
    --   end,
    --   relative = "editor",
    --   backdrop = false,
    --   wo = {
    --     spell = false,
    --     wrap = false,
    --   },
    -- },
  },
  -- indent = { enabled = true, animate = { enabled = false }, scope = { enabled = false } },
  input = { enabled = true },
  picker = {
    enabled = true,
    layouts = {
      select = {
        layout = {
          width = function()
            return layout.editor.width(
              constants.layout.select.scale,
              constants.layout.select.min,
              constants.layout.select.max
            )
          end,
          min_width = constants.layout.select.min,
          border = constants.window.border,
        },
      },
    },
    win = {
      input = {
        keys = {
          ["<Esc>"] = { "close", mode = { "n", "i" } },
        },
      },
    },
  },
})
