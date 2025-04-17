local message = require("builtin.utils.message")
local keymap = require("builtin.utils.keymap")

local M = {
  keymap.set_lazy_key({ "n", "x" }, "<Leader>cf", function()
    require("conform").format(
      { async = true, timeout_ms = 2000, lsp_fallback = "fallback" },
      function(err, did_edit)
        if err then
          message.warn(err)
        end
      end
    )
  end, { desc = "Code format" }),
}

return M
