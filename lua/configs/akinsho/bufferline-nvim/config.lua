local layout = require("builtin.utils.layout")
local path = require("commons.path")
local str = require("commons.str")

require("bufferline").setup({
  options = {
    numbers = "ordinal",
    close_command = "lua require('snacks').bufdelete({buf=%d,force=true})", -- snacks
    right_mouse_command = "lua require('snacks').bufdelete({buf=%d,force=true})", -- snacks
    name_formatter = function(buf)
      local max_name_len = layout.editor.width(0.334, 60, nil)
      local name = buf.name
      local len = name ~= nil and string.len(name) or 0
      if len > max_name_len then
        local half = math.floor(max_name_len / 2) - 1
        local left = string.sub(name, 1, half)
        local right = string.sub(name, len - half, len)
        name = left .. "…" .. right
      end
      return name
    end,
    max_name_length = layout.editor.width(0.334, 60, nil),
    diagnostics = false,
    get_element_icon = function(element)
      local current_bufpath = vim.api.nvim_buf_get_name(0)
      local icon_text, icon_color =
        require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
      if
        str.not_empty(current_bufpath)
        and str.not_empty(element.path)
        and path.normalize(current_bufpath, { expand = true, double_backslash = true })
          == path.normalize(element.path, { expand = true, double_backslash = true })
      then
        return icon_text, icon_color
      else
        return icon_text, "Comment"
      end
    end,
    hover = {
      enabled = false,
    },
  },
})
