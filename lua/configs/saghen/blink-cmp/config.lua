require("blink.cmp").setup({
  cmdline = {
    completion = {
      list = { selection = { preselect = false } },
      menu = { auto_show = true },
    },
    enabled = true,
    keymap = {
      ["<CR>"] = { "accept", "fallback" },

      -- Use <Tab> to accept if there are suggestions, or select next.
      ["<Tab>"] = {
        function(cmp)
          if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then
            return cmp.accept()
          end
        end,
        "show_and_insert",
        "select_next",
        "fallback",
      },
      -- Use <S-Tab> to select previous.
      ["<S-Tab>"] = { "select_prev", "fallback" },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
    },
  },
  completion = {
    documentation = { auto_show = true },
    menu = {
      draw = {
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
          { "source_name" },
        },
        components = {
          source_name = {
            width = { max = 10 },
            text = function(ctx)
              return "[" .. ctx.source_name .. "]"
            end,
            highlight = "BlinkCmpSource",
          },
        },
      },
    },
  },
  fuzzy = {
    implementation = "prefer_rust_with_warning",
  },
  keymap = {
    ["<CR>"] = { "accept", "fallback" },

    -- Use <Tab> to accept if there are suggestions, jump to next placeholder if already in an expanded snippet.
    ["<Tab>"] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.accept()
        else
          return cmp.select_and_accept()
        end
      end,
      "snippet_forward",
      "fallback",
    },
    -- Use <S-Tab> to jump to previous placeholder if already in an expanded snippet.
    ["<S-Tab>"] = { "snippet_backward", "fallback" },

    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },
    ["<C-n>"] = { "select_next", "fallback" },

    ["<C-f>"] = { "snippet_forward", "fallback" },
    ["<C-b>"] = { "snippet_backward", "fallback" },

    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
  },
  signature = {
    enabled = true,
  },
  snippets = { preset = "luasnip" },
})
