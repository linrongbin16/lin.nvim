local str = require("commons.str")

-- Whether previous char is whitespace.
---@return boolean
local function checkspace()
  local col = vim.fn.col(".") - 1
  -- If previous char is not the beginning of the line.
  if col > 0 then
    local line = vim.fn.getline(".")
    if type(line) == "string" and string.len(line) >= col then
      local ch = string.sub(line, col, col)
      -- If previous char is whitespace.
      if type(ch) == "string" and string.match(ch, "%s") ~= nil then
        return true
      end
    end
  end
  return false
end

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
            -- if not checkspace() then
            return cmp.accept()
            -- end
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
          -- elseif not checkspace() then
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
  },
})
