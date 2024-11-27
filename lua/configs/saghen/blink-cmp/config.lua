require("blink.cmp").setup({
  keymap = {
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = { "accept", "fallback" },
    ["<S-Tab>"] = { "fallback" },

    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },
    ["<C-n>"] = { "select_next", "fallback" },

    ["<C-f>"] = { "snippet_forward", "fallback" },
    ["<C-b>"] = { "snippet_backward", "fallback" },

    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
  },
  trigger = {
    accept = { auto_brackets = { enabled = true } },
    signature_help = {
      enabled = true,
    },
  },
})
