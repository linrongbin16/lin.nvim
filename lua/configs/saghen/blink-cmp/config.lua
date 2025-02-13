local function choose_auto_insert(ctx)
  if ctx.mode == "cmdline" then
    return true
  end
  if
    type(ctx.bufnr) == "number"
    and ctx.bufnr >= 0
    and vim.api.nvim_buf_is_valid(ctx.bufnr)
    and vim.api.nvim_get_option_value("buftype", { buf = ctx.bufnr }) == "prompt"
  then
    return true
  end
  local cur_win = vim.api.nvim_get_current_win()
  if vim.fn.win_gettype(cur_win) == "popup" then
    return true
  end
  return false
end

local function choose_preselect(ctx)
  return not choose_auto_insert(ctx)
end

require("blink.cmp").setup({
  completion = {
    list = {
      selection = {
        -- Use "auto_insert" for specific buf/win.
        auto_insert = choose_auto_insert,
        -- Otherwise use "preselect".
        preselect = choose_preselect,
      },
    },
    accept = { auto_brackets = { enabled = true } },
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
  keymap = {
    ["<CR>"] = { "accept", "fallback" },

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
  signature = {
    enabled = true,
  },
  snippets = { preset = "luasnip" },
})
