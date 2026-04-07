-- ---- KEY ----
-- Disable unused builtin key mappings

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
}

for p in ipairs(bracket_pairs) do
  local mode = p.mode --[[@as string]]
  local key1 = "]" .. p.key --[[@as string]]
  local key2 = "]" .. p.key --[[@as string]]
  vim.keymap.del(mode, key1)
  vim.keymap.del(mode, key2)
end
