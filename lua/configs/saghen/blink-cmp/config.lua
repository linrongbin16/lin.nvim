local str = require("commons.str")

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
    -- Disable prefetch_on_insert if you use AI plugins: minuet-ai.nvim or codecompanion.nvim
    -- trigger = { prefetch_on_insert = false },
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
          -- lspkind, nvim-highlight-colors
          kind_icon = {
            text = function(ctx)
              -- default kind icon
              local icon = ctx.kind_icon
              -- if LSP source, check for color derived from documentation
              if str.find(ctx.item.source_name, "LSP") ~= nil then
                local color_item = require("nvim-highlight-colors").format(
                  ctx.item.documentation,
                  { kind = ctx.kind }
                )
                if color_item and color_item.abbr ~= "" then
                  icon = color_item.abbr
                end
              end
              return icon .. ctx.icon_gap
            end,
            highlight = function(ctx)
              -- default highlight group
              local highlight = "BlinkCmpKind" .. ctx.kind
              -- if LSP source, check for color derived from documentation
              if str.find(ctx.item.source_name, "LSP") ~= nil then
                local color_item = require("nvim-highlight-colors").format(
                  ctx.item.documentation,
                  { kind = ctx.kind }
                )
                if color_item and color_item.abbr_hl_group then
                  highlight = color_item.abbr_hl_group
                end
              end
              return highlight
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

    -- For minuet-ai.nvim
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

    -- For codecompanion.nvim
    --
    -- per_filetype = {
    --   codecompanion = { "codecompanion" },
    -- },
  },
})
