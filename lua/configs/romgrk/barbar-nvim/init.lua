vim.g.barbar_auto_setup = false

local parts = {
  "ADDED",
  "Btn",
  "CHANGED",
  "DELETED",
  "ERROR",
  "HINT",
  "Icon",
  "Index",
  "INFO",
  "Mod",
  "ModBtn",
  "Number",
  "Sign",
  "SignRight",
  "Target",
  "WARN",
}
for part in ipairs(parts) do
  vim.api.nvim_set_hl(0, "BufferInactive" .. part, { link = "Comment" })
end
