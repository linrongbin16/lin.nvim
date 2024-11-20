require("dropbar").setup({
  bar = {
    update_debounce = 100,
    sources = function(buf, _)
      local sources = require("dropbar.sources")
      -- local utils = require("dropbar.utils")
      return { sources.path }
    end,
  },
})
