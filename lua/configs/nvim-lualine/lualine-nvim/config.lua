local tbl = require("commons.tbl")

local constants = require("builtin.constants")

local function GitDiffCondition()
  return vim.fn.exists("b:gitsigns_status_dict") > 0
end

local function GitDiff()
  local changes = vim.b.gitsigns_status_dict or {}
  return {
    added = changes.added or 0,
    modified = changes.changed or 0,
    removed = changes.removed or 0,
  }
end

local function LspProgress()
  local status = require("lsp-progress").progress()
  return type(status) == "string" and string.len(status) > 0 and status or ""
end

local function LspClients()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local names = {}
  if type(clients) == "table" then
    for _, c in ipairs(clients) do
      if type(c) == "table" and type(c.name) == "string" and string.len(c.name) > 0 then
        table.insert(names, c.name)
      end
    end
  end
  if tbl.list_empty(names) then
    return ""
  else
    return " " .. table.concat(names, ",")
  end
end

local function Location()
  return " %2l:%-2v"
end

local function Progress()
  local bar = " "
  local line_fraction = math.floor(vim.fn.line(".") / vim.fn.line("$") * 100)
  local value = ""
  if line_fraction >= 100 then
    value = "Bot"
  elseif line_fraction <= 0 then
    value = "Top"
  else
    value = string.format("%2d%%%%", line_fraction)
  end
  return bar .. value
end

local function CursorHex()
  return "0x%04B"
end

local empty_component_separators = { left = "", right = "" }
local empty_section_separators = { left = "", right = "" }

-- style-1: A > B > C ---- X < Y < Z
local angle_component_separators = { left = "", right = "" }
local angle_section_separators = { left = "", right = "" }

-- style-2: A \ B \ C ---- X / Y / Z
local slash_component_separators = { left = "", right = "" }
local slash_section_separators = { left = "", right = "" }

local config = {
  options = {
    icons_enabled = true,
    component_separators = empty_component_separators,
    section_separators = slash_section_separators,
    refresh = {
      statusline = 1000,
      refresh_time = 24,
      events = {
        "WinEnter",
        "BufEnter",
        "BufWritePost",
        "SessionLoadPost",
        "FileChangedShellPost",
        "VimResized",
        "Filetype",
        "CursorMoved",
        "CursorMovedI",
        "ModeChanged",
        "FocusGained",
        "TermEnter",
        "TermLeave",
      },
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "filename" },
    lualine_c = {
      "branch",
      {
        "diff",
        cond = GitDiffCondition,
        source = GitDiff,
      },
      LspProgress,
    },
    lualine_x = {
      {
        "diagnostics",
        symbols = {
          error = constants.diagnostics.error .. " ",
          warn = constants.diagnostics.warning .. " ",
          info = constants.diagnostics.info .. " ",
          hint = constants.diagnostics.hint .. " ",
        },
      },
      LspClients,
      "filetype",
    },
    lualine_y = {
      "encoding",
      {
        "fileformat",
        symbols = {
          unix = "unix",
          dos = "dos",
          mac = "mac",
        },
      },
    },
    lualine_z = {
      -- CursorHex,
      Location,
      Progress,
    },
  },
}

require("lualine").setup(config)

-- listen to lsp-progress event and refresh
local lualine_augroup = vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = lualine_augroup,
  pattern = { "LspProgressStatusUpdated" },
  callback = function()
    require("lualine").refresh({
      place = { "statusline" },
    })
  end,
})
vim.api.nvim_create_autocmd({ "ModeChanged", "BufReadPre", "BufNewFile", "WinEnter" }, {
  group = lualine_augroup,
  callback = function()
    require("lualine").refresh({
      place = { "statusline" },
    })
  end,
})
