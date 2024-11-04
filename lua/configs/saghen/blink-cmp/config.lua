require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<Tab>"] = {
      function(cmp)
        if cmp.is_in_snippet() then
          return cmp.accept()
        else
          return cmp.select_and_accept()
        end
      end,
      "snippet_forward",
      "fallback",
    },
    ["<CR>"] = { "accept", "fallback" },
  },
  trigger = {
    signature_help = {
      enabled = true,
    },
  },
})
