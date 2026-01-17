local str = require("commons.str")
local lspkind = require("lspkind")

require("blink.cmp").setup({
  cmdline = {
    enabled = true,
    completion = {
      list = { selection = { preselect = false } },
      menu = { auto_show = true },
      ghost_text = { enabled = false },
    },
    keymap = {
      ["<CR>"] = { "accept", "fallback" },

      -- Use <Tab> to accept if there are suggestions, or select next.
      ["<Tab>"] = {
        function(cmp)
          if cmp.is_visible() then
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
    trigger = {
      prefetch_on_insert = false,
    },
    documentation = { auto_show = true },
    menu = {
      draw = {
        treesitter = { "lsp" },
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
          { "source_name" },
        },
        components = {
          kind_icon = {
            text = function(ctx)
              local icon = ctx.kind_icon
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                if dev_icon then
                  icon = dev_icon
                end
              elseif lspkind.symbol_map[ctx.kind] ~= nil then
                icon = lspkind.symbol_map[ctx.kind]
              end
              return icon .. ctx.icon_gap
            end,
            highlight = function(ctx)
              local hl = ctx.kind_hl
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                if dev_icon then
                  hl = dev_hl
                end
              end
              return hl
            end,
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
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    providers = {
      lsp = {
        async = true,
      },
    },

    -- For minuet-ai with local llama.cpp model
    --
    -- default = { "lsp", "path", "snippets", "buffer", "minuet" },
    -- providers = {
    --   minuet = {
    --     name = "minuet",
    --     module = "minuet.blink",
    --     async = true,
    --     -- Should match minuet.config.request_timeout * 1000,
    --     -- since minuet.config.request_timeout is in seconds
    --     timeout_ms = 3000,
    --     score_offset = 50, -- Gives minuet higher priority among suggestions
    --   },
    -- },
  },
})
