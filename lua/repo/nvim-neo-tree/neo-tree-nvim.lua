local constants = require('conf/constants')

require("neo-tree").setup({
    popup_border_style = constants.ui.border,
    filesystem = {
      filtered_items = {
        visible = true,
      },
      window = {
        mappings = {
          ["[c"] = "prev_git_modified",
          ["]c"] = "next_git_modified",
        }
      }
    },
})

