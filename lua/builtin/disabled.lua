-- Disable useless builtin plugins

-- Replace with 'neo-tree.nvim'
vim.g.loaded_netrwPlugin = 1

-- Replace with 'vim-matchup'
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

-- Not used
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tutor = 1
vim.g.loaded_tohtml = 1
vim.g.loaded_man = 1

-- Unused key mappings
local bracket_pairs = {
  {
    mode = "x",
    key = "n",
  },
  {
    mode = "n",
    key = "q",
  },
  {
    mode = "n",
    key = "Q",
  },
  {
    mode = "n",
    key = "B",
  },
  {
    mode = "n",
    key = "D",
  },
  {
    mode = "n",
    key = "a",
  },
  {
    mode = "n",
    key = "A",
  },
  {
    mode = "n",
    key = "l",
  },
  {
    mode = "n",
    key = "L",
  },
  {
    mode = "n",
    key = "t",
  },
  {
    mode = "n",
    key = "T",
  },
  {
    mode = "n",
    key = "<Space>",
  },
  {
    mode = "n",
    key = "<C-T>",
  },
  {
    mode = "n",
    key = "<C-L>",
  },
  {
    mode = "n",
    key = "<C-Q>",
  },
}
for _, p in ipairs(bracket_pairs) do
  local mode = p.mode --[[@as string]]
  local key1 = "]" .. p.key --[[@as string]]
  local key2 = "[" .. p.key --[[@as string]]
  vim.keymap.del(mode, key1)
  vim.keymap.del(mode, key2)
end

local n_suffixes = { "i", "a" }
for _, kc in ipairs(n_suffixes) do
  local key = kc .. "n"
  -- print(string.format("keymap del %s", vim.inspect(key)))
  vim.keymap.del({ "o", "x" }, key)
end

local gr_prefixes = {
  { mode = "n", key = "t" },
  { mode = "n", key = "i" },
  { mode = "n", key = "r" },
  { mode = "n", key = "x" },
  { mode = { "n", "x" }, key = "a" },
  { mode = "n", key = "n" },
}
for _, kc in ipairs(gr_prefixes) do
  local mode = kc.mode
  local key = "gr" .. kc.key
  vim.keymap.del(mode, key)
end

vim.keymap.del("o", "gc")
vim.keymap.del("n", "<C-W>d")
vim.keymap.del("s", "<C-S>")
