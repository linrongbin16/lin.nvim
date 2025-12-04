local str = require("commons.str")
local tbl = require("commons.tbl")
local spawn = require("commons.spawn")

local constants = require("builtin.constants")

local git_branch_cache = nil
local git_status_cache = nil

local function LspProgress()
  local max_size = math.max(10, (vim.o.columns + 2) / 2)
  local status = require("lsp-progress").progress({ max_size = max_size })
  return type(status) == "string" and string.len(status) > 0 and status or ""
end

local function LspClients()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local names = {}
  if type(clients) == "table" then
    for _, c in ipairs(clients) do
      if type(c) == "table" and type(c.name) == "string" and str.not_empty(c.name) then
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
      statusline = 5000,
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "filename" },
    lualine_c = {
      "branch",
      "diff",
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
      {
        "fileformat",
        symbols = {
          unix = " LF", -- e712
          dos = " CRLF", -- e70f
          mac = " CR", -- e711
        },
      },
      {
        "encoding",
        fmt = function(text)
          local FileEncodingIcons = {
            ["utf-8"] = "󰉿",
            ["utf-16"] = "󰊀",
            ["utf-32"] = "󰊁",
            ["utf-8mb4"] = "󰊂",
            ["utf-16le"] = "󰊃",
            ["utf-16be"] = "󰊄",
          }
          local icon = FileEncodingIcons[text]
          if str.empty(icon) then
            return text
          else
            return icon .. " " .. text
          end
        end,
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
  pattern = { "LspProgressStatusUpdated", "LualineGitBranchUpdated" },
  callback = function()
    require("lualine").refresh({
      place = { "statusline" },
    })
  end,
})
vim.api.nvim_create_autocmd(
  { "ModeChanged", "BufReadPre", "BufNewFile", "WinEnter", "LspAttach" },
  {
    group = lualine_augroup,
    callback = function()
      require("lualine").refresh({
        place = { "statusline" },
      })
    end,
  }
)
