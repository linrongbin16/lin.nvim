local compare = require("cmp.config.compare")

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

---@type table<integer, integer>
local modified_priority = {
  [types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
  [types.lsp.CompletionItemKind.Snippet] = 0, -- top
  [types.lsp.CompletionItemKind.Keyword] = 0, -- top
  [types.lsp.CompletionItemKind.Text] = 100, -- bottom
}
---@param kind integer: kind of completion entry
local function modified_kind(kind)
  return modified_priority[kind] or kind
end

local function compare_lsp_kind(entry1, entry2) -- sort by compare kind (Variable, Function etc)
  local kind1 = modified_kind(entry1:get_kind())
  local kind2 = modified_kind(entry2:get_kind())
  if kind1 ~= kind2 then
    return kind1 - kind2 < 0
  end
end

local function compare_lsp_sort(entry1, entry2) -- score by lsp, if available
  local t1 = entry1.completion_item.sortText
  local t2 = entry2.completion_item.sortText
  if t1 ~= nil and t2 ~= nil and t1 ~= t2 then
    return t1 < t2
  end
end

-- nvim_lsp
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
  capabilities = capabilities,
})

-- luasnip
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

local select_opts = { behavior = cmp.SelectBehavior.Select }
local setup_opts = {
  completion = {
    completeopt = "menu,menuone,noinsert",
    keyword_length = 1,
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "async_path" },
  }),
  formatting = {
    format = function(entry, vim_item)
      if vim.tbl_contains({ "async_path" }, entry.source.name) then
        local icon, hl_group =
          require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
        if icon then
          vim_item.kind = icon
          vim_item.kind_hl_group = hl_group
          return vim_item
        end
      end
      return vim_item
    end,
  },
  sorting = {
    comparators = {
      compare.recently_used,
      compare.exact,
      compare_lsp_kind,
      compare_lsp_sort,
      compare.score,
      compare.offset,
      compare.locality,
      -- compare.scopes,
      require("cmp-under-comparator").under,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },
  performance = {
    max_view_entries = 15,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
    ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
    ["<Down>"] = cmp.mapping.select_next_item(select_opts),
    ["<C-n>"] = cmp.mapping.select_next_item(select_opts),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if luasnip.expandable() then
          luasnip.expand()
        else
          cmp.confirm({
            select = true,
          })
        end
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true })
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
}

cmp.setup(setup_opts)

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "buffer" },
  }),
})

--- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "async_path" },
  }, {
    {
      name = "cmdline",
      option = {
        ignore_cmds = { "Man", "!", "tag" },
      },
    },
  }),
})
