require("blink.cmp").setup({
  keymap = {
    ["<CR>"] = { "accept", "fallback" },

    -- ["<Tab>"] = { "accept", "fallback" },
    -- ["<S-Tab>"] = { "fallback" },

    -- Use <Tab> to accept if there are suggestions, or jump to next placeholder if already in an expanded snippet.
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
  snippets = {
    expand = function(snippet)
      require("luasnip").lsp_expand(snippet)
    end,
    active = function(filter)
      if filter and filter.direction then
        return require("luasnip").jumpable(filter.direction)
      end
      return require("luasnip").in_snippet()
    end,
    jump = function(direction)
      require("luasnip").jump(direction)
    end,
  },
  completion = {
    list = {
      -- Use "auto_insert" for cmdline/popup/prompt, otherwise use "preselect".
      selection = function(ctx)
        if ctx.mode == "cmdline" then
          return "auto_insert"
        end
        if
          type(ctx.bufnr) == "number"
          and ctx.bufnr >= 0
          and vim.api.nvim_buf_is_valid(ctx.bufnr)
          and vim.api.nvim_get_option_value("buftype", { buf = ctx.bufnr }) == "prompt"
        then
          return "auto_insert"
        end
        local cur_win = vim.api.nvim_get_current_win()
        if vim.fn.win_gettype(cur_win) == "popup" then
          return "auto_insert"
        end
        return "preselect"
      end,
    },
    accept = { auto_brackets = { enabled = true } },
    documentation = { auto_show = true },
  },
  sources = {
    min_keyword_length = function()
      return 1
    end,
  },
  signature = {
    enabled = true,
  },
})
