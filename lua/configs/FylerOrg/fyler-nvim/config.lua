local constants = require("api.constants")

require("fyler").setup({
  auto_confirm_simple_mutation = true,
  extensions = {
    git = { enabled = true },
    -- git = { enabled = true, inline = false },
    trash = { enabled = true },
    watcher = { enabled = true },
  },
  -- External integrations (e.g., icon provider)
  integrations = {
    icon = "nvim_web_devicons",
  },
  kind = "floating",
  kind_presets = {
    floating = {
      border = constants.window.border,
      height = string.format("%.0f%%", constants.layout.window.scale * 100),
      width = string.format("%.0f%%", constants.layout.window.scale * 100),
      -- mappings = {
      --   n = {
      --     ["<CR>"] = {
      --       action = "select",
      --       args = { close = true, pick = false },
      --     },
      --   },
      -- },
    },
    -- replace = {
    --   mappings = {
    --     n = {
    --       ["<CR>"] = {
    --         action = "select",
    --         args = { close = true, pick = false },
    --       },
    --     },
    --   },
    -- },
    split_above = { height = "50%" },
    split_above_all = { height = "50%" },
    split_below = { height = "50%" },
    split_below_all = { height = "50%" },
    split_left = { width = "25%" },
    split_left_most = { width = "25%" },
    split_right = { width = "25%" },
    split_right_most = { width = "25%" },
  },
  -- Key mappings organized by mode (see: fyler.Mapping)
  mappings = {
    n = {
      ["<BS>"] = {
        action = "visit",
        args = { parent = true },
        desc = "Go to parent directory",
      },
      -- ["."] = {
      --   action = "visit",
      --   args = { cursor = true },
      --   desc = "Enter directory under cursor",
      -- },
      ["R"] = {
        action = "refresh",
        args = { recursive = true, force = true },
        desc = "Force refresh tree",
      },
      ["h"] = {
        action = "shrink",
        args = { parent = true },
        desc = "Collapse parent directory",
      },
      ["l"] = {
        action = "select",
        args = { pick = true },
        desc = "Open with window picker",
      },
      ["<CR>"] = {
        action = "select",
        args = { pick = true },
        desc = "Open with window picker",
      },
      ["<2-LeftMouse>"] = {
        action = "select",
        args = { pick = true },
        desc = "Open with window picker",
      },
      ["="] = {
        action = "visit",
        desc = "Go to root directory",
      },
      -- ["g."] = {
      --   action = "toggle_ui",
      --   args = { "hidden_items" },
      --   desc = "Toggle hidden files",
      -- },
      -- ["gi"] = {
      --   action = "toggle_ui",
      --   args = { "indent_guides" },
      --   desc = "Toggle indent guides",
      -- },
      ["q"] = {
        action = "close",
        desc = "Close finder",
      },
    },
  },
  ui = {
    hidden_items = {
      switches = {},
      patterns = {},
      always_visible = {},
      always_hidden = {},
    },
    indent_guides = true,
  },
  follow_root_dir = true,
})
