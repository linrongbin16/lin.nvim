local uv = require("commons.uv")
local str = require("commons.str")
local tbl = require("commons.tbl")
local color_hl = require("commons.color.hl")
local color_hsl = require("commons.color.hsl")
local spawn = require("commons.spawn")

local constants = require("builtin.constants")

local black = "#000000"
local white = "#ffffff"
local red = "#FF0000"
local green = "#008000"
local blue = "#0000FF"
local cyan = "#00FFFF"
local grey = "#808080"
local orange = "#D2691E"
local yellow = "#FFFF00"
local purple = "#800080"
local magenta = "#FF00FF"
local bright_black = "#808080"
local bright_red = "#CD5C5C"
local bright_green = "#90EE90"
local bright_yellow = "#FFFFE0"
local bright_blue = "#ADD8E6"
local bright_magenta = "#EE82EE"
local bright_cyan = "#E0FFFF"
local bright_white = "#C0C0C0"

local left_slant = ""
local right_slant = ""

local OS_UNAME = uv.os_uname()

local ModeNames = {
  ["n"] = "NORMAL",
  ["no"] = "O-PENDING",
  ["nov"] = "O-PENDING",
  ["noV"] = "O-PENDING",
  ["no\22"] = "O-PENDING",
  ["niI"] = "NORMAL",
  ["niR"] = "NORMAL",
  ["niV"] = "NORMAL",
  ["nt"] = "NORMAL",
  ["ntT"] = "NORMAL",
  ["v"] = "VISUAL",
  ["vs"] = "VISUAL",
  ["V"] = "V-LINE",
  ["Vs"] = "V-LINE",
  ["\22"] = "V-BLOCK",
  ["\22s"] = "V-BLOCK",
  ["s"] = "SELECT",
  ["S"] = "S-LINE",
  ["\19"] = "S-BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["ix"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rc"] = "REPLACE",
  ["Rx"] = "REPLACE",
  ["Rv"] = "V-REPLACE",
  ["Rvc"] = "V-REPLACE",
  ["Rvx"] = "V-REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "EX",
  ["ce"] = "EX",
  ["r"] = "REPLACE",
  ["rm"] = "MORE",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
}

local ModeHighlights = {
  NORMAL = { fg = "normal_fg1", bg = "normal_bg1" },
  ["O-PENDING"] = { fg = "normal_fg1", bg = "normal_bg1" },
  INSERT = { fg = "insert_fg", bg = "insert_bg" },
  VISUAL = { fg = "visual_fg", bg = "visual_bg" },
  ["V-LINE"] = { fg = "visual_fg", bg = "visual_bg" },
  ["V-BLOCK"] = { fg = "visual_fg", bg = "visual_bg" },
  SELECT = { fg = "visual_fg", bg = "visual_bg" },
  ["S-LINE"] = { fg = "visual_fg", bg = "visual_bg" },
  ["S-BLOCK"] = { fg = "visual_fg", bg = "visual_bg" },
  REPLACE = { fg = "replace_fg", bg = "replace_bg" },
  MORE = { fg = "replace_fg", bg = "replace_bg" },
  ["V-REPLACE"] = { fg = "replace_fg", bg = "replace_bg" },
  COMMAND = { fg = "command_fg", bg = "command_bg" },
  EX = { fg = "command_fg", bg = "command_bg" },
  CONFIRM = { fg = "command_fg", bg = "command_bg" },
  SHELL = { fg = "command_fg", bg = "command_bg" },
  TERMINAL = { fg = "command_fg", bg = "command_bg" },
}

local function GetModeName(mode)
  return ModeNames[mode] or "???"
end

local function GetModeHighlight(mode)
  local mode_name = GetModeName(mode)
  if type(mode_name) == "string" and ModeHighlights[mode_name] then
    return ModeHighlights[mode_name]
  else
    return ModeHighlights.NORMAL
  end
end

local function GetOsIcon()
  local uname = OS_UNAME.sysname
  if uname:match("Darwin") then
    return ""
  elseif uname:match("Windows") then
    return ""
  elseif uname:match("Linux") then
    if type(OS_UNAME.release) == "string" and OS_UNAME.release:find("arch") then
      return ""
    end
    return ""
  else
    return "󱚟"
  end
end

local Mode = {
  init = function(self)
    self.mode = vim.api.nvim_get_mode().mode
  end,
  hl = function(self)
    local mode_hl = GetModeHighlight(self.mode)
    return { fg = mode_hl.fg, bg = mode_hl.bg, bold = true }
  end,
  update = { "ModeChanged" },

  -- os icon
  {
    provider = function(self)
      return " " .. GetOsIcon() .. " "
    end,
  },
  -- mode
  {
    provider = function(self)
      return GetModeName(self.mode) .. " "
    end,
  },
  -- separator
  {
    provider = right_slant,
    hl = function(self)
      local mode_hl = GetModeHighlight(self.mode)
      return { fg = mode_hl.bg, bg = "normal_bg2" }
    end,
  },
}

local FileName = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  hl = { fg = "normal_fg2", bg = "normal_bg2" },

  -- file name
  {
    provider = " %t ",
  },
  {
    provider = function(self)
      if str.empty(self.filename) then
        return ""
      end
      local modifiable = vim.api.nvim_get_option_value("modifiable", { buf = 0 })
      local readonly = vim.api.nvim_get_option_value("readonly", { buf = 0 })
      if not modifiable or readonly then
        return "[] "
      end
      local modified = vim.api.nvim_get_option_value("modified", { buf = 0 })
      if modified then
        return "[] "
      end
      return ""
    end,
    update = { "OptionSet", "BufWritePost", "BufEnter", "WinEnter" },
  },
  -- file size
  {
    provider = function(self)
      if str.empty(self.filename) then
        return ""
      end
      local fstat = uv.fs_stat(self.filename)
      local fsize_value = tbl.tbl_get(fstat, "size")
      if type(fsize_value) ~= "number" or fsize_value <= 0 then
        return ""
      end
      local suffixes = { "B", "KB", "MB", "GB" }
      local i = 1
      while fsize_value > 1024 and i < #suffixes do
        fsize_value = fsize_value / 1024
        i = i + 1
      end

      local fsize_format = i == 1 and "[%d %s] " or "[%.1f %s] "
      return string.format(fsize_format, fsize_value, suffixes[i])
    end,
    update = { "OptionSet", "BufWritePost", "BufEnter", "WinEnter" },
  },
  {
    provider = right_slant,
    hl = { fg = "normal_bg2", bg = "normal_bg3" },
  },
}

local git_branch_name_cache = nil
local git_branch_status_cache = nil

local GitBranch = {
  hl = { fg = "normal_fg3", bg = "normal_bg3" },
  update = { "User", pattern = "HeirlineGitBranchUpdated" },

  {
    provider = function(self)
      if str.not_empty(git_branch_name_cache) then
        return "  " .. git_branch_name_cache .. " "
      else
        return ""
      end
    end,
  },
  {
    provider = function(self)
      if type(git_branch_status_cache) == "table" and git_branch_status_cache["changed"] ~= nil then
        return "* "
      else
        return ""
      end
    end,
    hl = function(self)
      return { fg = "git_dirty", bg = "normal_bg3" }
    end,
  },
  {
    provider = function(self)
      if
        type(git_branch_status_cache) == "table"
        and type(git_branch_status_cache["ahead"]) == "number"
      then
        return string.format("↑[%d] ", git_branch_status_cache["ahead"])
      else
        return ""
      end
    end,
    hl = function(self)
      return { fg = "git_ahead", bg = "normal_bg3" }
    end,
  },
  {
    provider = function(self)
      if
        type(git_branch_status_cache) == "table"
        and type(git_branch_status_cache["behind"]) == "number"
      then
        return string.format("↓[%d] ", git_branch_status_cache["behind"])
      else
        return ""
      end
    end,
    hl = function(self)
      return { fg = "git_behind", bg = "normal_bg3" }
    end,
  },
  {
    provider = right_slant,
    hl = { fg = "normal_bg3", bg = "normal_bg4" },
  },
}

local GitDiff = {
  init = function(self)
    self.summary = {}
    if vim.fn.exists("*GitGutterGetHunkSummary") > 0 then
      self.summary = vim.fn["GitGutterGetHunkSummary"]() or {}
    end
  end,
  hl = { fg = "normal_fg4", bg = "normal_bg4" },
  update = { "User", pattern = "GitGutter" },

  {
    provider = function(self)
      local value = self.summary[1] or 0
      if value > 0 then
        return string.format(" +%d", value)
      else
        return ""
      end
    end,
    hl = { fg = "git_add", bg = "normal_bg4" },
  },
  {
    provider = function(self)
      local value = self.summary[2] or 0
      if value > 0 then
        return string.format(" ~%d", value)
      else
        return ""
      end
    end,
    hl = { fg = "git_change", bg = "normal_bg4" },
  },
  {
    provider = function(self)
      local value = self.summary[3] or 0
      if value > 0 then
        return string.format(" -%d", value)
      else
        return ""
      end
    end,
    hl = { fg = "git_delete", bg = "normal_bg4" },
  },
}

local LspStatus = {
  hl = { fg = "normal_fg4", bg = "normal_bg4" },
  provider = function()
    local width = math.max(vim.o.columns - math.max(100, math.floor(vim.o.columns / 2)), 3)
    local result = require("lsp-progress").progress({
      max_size = width,
    })
    if str.not_empty(result) then
      return " " .. result
    end
    return ""
  end,
  update = {
    "User",
    pattern = "LspProgressStatusUpdated",
    callback = function()
      vim.schedule(function()
        vim.cmd("redrawstatus")
      end)
    end,
  },
}

local SearchCount = {
  hl = { fg = "normal_fg4", bg = "normal_bg4" },
  provider = function()
    if vim.v.hlsearch == 0 then
      return ""
    end
    local ok, result = pcall(vim.fn.searchcount, { maxcount = 100, timeout = 500 })
    if not ok or tbl.tbl_empty(result) then
      return ""
    end
    local denominator = math.min(result.total, result.maxcount)
    return string.format("[%d/%d] ", result.current, denominator)
  end,
  update = {
    "SearchWrapped",
    "CmdlineEnter",
    "CmdlineLeave",
  },
}

local DiagnosticSeverity = { "ERROR", "WARN", "INFO", "HINT" }

local DiagnosticSigns = {
  constants.diagnostic.signs.error,
  constants.diagnostic.signs.warning,
  constants.diagnostic.signs.info,
  constants.diagnostic.signs.hint,
}

local function GetDiagnosticText(level)
  local value =
    #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[DiagnosticSeverity[level]] })
  if value <= 0 then
    return ""
  else
    return string.format("%s %d ", DiagnosticSigns[level], value)
  end
end

local DiagnosticColors = {
  "diagnostic_error",
  "diagnostic_warn",
  "diagnostic_info",
  "diagnostic_hint",
}

local function GetDiagnosticHighlight(level)
  return { fg = DiagnosticColors[level], bg = "normal_bg4" }
end

local Diagnostic = {
  hl = { fg = "normal_fg4", bg = "normal_bg4" },
  update = { "DiagnosticChanged" },

  {
    provider = function()
      return GetDiagnosticText(1)
    end,
    hl = GetDiagnosticHighlight(1),
  },
  {
    provider = function()
      return GetDiagnosticText(2)
    end,
    hl = GetDiagnosticHighlight(2),
  },
  {
    provider = function()
      return GetDiagnosticText(3)
    end,
    hl = GetDiagnosticHighlight(3),
  },
  {
    provider = function()
      return GetDiagnosticText(4)
    end,
    hl = GetDiagnosticHighlight(4),
  },
}

local FileEncodingIcons = {
  ["utf-8"] = "󰉿",
  ["utf-16"] = "󰊀",
  ["utf-32"] = "󰊁",
  ["utf-8mb4"] = "󰊂",
  ["utf-16le"] = "󰊃",
  ["utf-16be"] = "󰊄",
}

local FileEncoding = {
  hl = { fg = "normal_fg3", bg = "normal_bg3" },

  {
    provider = left_slant,
    hl = { fg = "normal_bg3", bg = "normal_bg4" },
  },
  {
    provider = function()
      local text = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
      if str.empty(text) then
        return ""
      end

      local icon = FileEncodingIcons[text]
      if str.empty(icon) then
        return " " .. text .. " "
      else
        return " " .. icon .. " " .. text .. " "
      end
    end,
    update = {
      "BufEnter",
    },
  },
}

local FileFormatIcons = {
  unix = " LF", -- e712
  dos = " CRLF", -- e70f
  mac = " CR", -- e711
}

local FileFormat = {
  hl = { fg = "normal_fg3", bg = "normal_bg3" },
  provider = function(self)
    local text = vim.bo.fileformat
    if str.empty(text) then
      return ""
    end

    local icon = FileFormatIcons[text]
    if str.empty(icon) then
      return " " .. text .. " "
    else
      return " " .. icon .. " "
    end
  end,
  update = {
    "BufEnter",
  },
}

local FileType = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0) or ""
    self.filename_ext = vim.fn.fnamemodify(self.filename, ":e") or ""
    self.devicons = require("nvim-web-devicons")
  end,
  hl = { fg = "normal_fg2", bg = "normal_bg2" },

  {
    provider = left_slant,
    hl = { fg = "normal_bg2", bg = "normal_bg3" },
  },
  {
    provider = function(self)
      if str.empty(self.filename_ext) then
        return ""
      end
      local text, _ =
        self.devicons.get_icon_color(self.filename, self.filename_ext, { default = true })
      if str.not_empty(text) then
        return " " .. text .. " "
      else
        return "  "
      end
    end,
    hl = function(self)
      local _, color =
        self.devicons.get_icon_color(self.filename, self.filename_ext, { default = true })
      if str.not_empty(color) then
        return { fg = color, bg = "normal_bg2" }
      else
        return { fg = "normal_fg2", bg = "normal_bg2" }
      end
    end,
    update = { "BufEnter" },
  },
  {
    provider = function(self)
      if str.empty(self.filename) then
        return ""
      end
      local ft = vim.filetype.match({ filename = self.filename }) or ""
      if str.empty(ft) then
        return ""
      end
      return ft .. " "
    end,
    update = { "BufEnter" },
  },
}

local Location = {
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  hl = function(self)
    local mode_hl = GetModeHighlight(self.mode)
    return { fg = mode_hl.fg, bg = mode_hl.bg, bold = true }
  end,

  {
    provider = left_slant,
    hl = function(self)
      local mode_hl = GetModeHighlight(self.mode)
      return { fg = mode_hl.bg, bg = "normal_bg2", bold = true }
    end,
  },
  {
    provider = "  %2l:%-2c",
  },
}

local CursorHex = {
  init = function(self)
    self.mode = vim.api.nvim_get_mode().mode
  end,
  hl = function(self)
    local mode_hl = GetModeHighlight(self.mode)
    return { fg = mode_hl.fg, bg = mode_hl.bg, bold = true }
  end,
  provider = " 0x%04B",
}

local Progress = {
  init = function(self)
    self.mode = vim.api.nvim_get_mode().mode
  end,
  hl = function(self)
    local mode_hl = GetModeHighlight(self.mode)
    return { fg = mode_hl.fg, bg = mode_hl.bg, bold = true }
  end,
  provider = "  %P ",
}

local StatusLine = {
  Mode,
  FileName,
  GitBranch,
  GitDiff,
  LspStatus,
  { provider = "%=", hl = { fg = "normal_fg4", bg = "normal_bg4" } },
  SearchCount,
  Diagnostic,
  FileEncoding,
  FileFormat,
  FileType,
  Location,
  CursorHex,
  Progress,
}

-- Get RGB color code from `g:terminal_color_0` ~ `g:terminal_color_10`, or fallback to default color.
--- @param number integer
--- @param fallback string
--- @return string
local function get_terminal_color(number, fallback)
  local color_name = string.format("terminal_color_%d", number)
  local color = vim.g[color_name]
  if str.not_empty(color) then
    return color
  else
    return fallback
  end
end

-- lualine auto-theme utils {

-- fg and bg must have this much contrast range 0 < contrast_threshold < 0.5
local contrast_threshold = 0.3
-- how much brightness is changed in percentage for light and dark themes
local brightness_modifier_parameter = 10

-- Turns #rrggbb -> { red, green, blue }
local function rgb_str2num(rgb_color_str)
  if rgb_color_str:find("#") == 1 then
    rgb_color_str = rgb_color_str:sub(2, #rgb_color_str)
  end
  local red = tonumber(rgb_color_str:sub(1, 2), 16)
  local green = tonumber(rgb_color_str:sub(3, 4), 16)
  local blue = tonumber(rgb_color_str:sub(5, 6), 16)
  return { red = red, green = green, blue = blue }
end

-- Turns { red, green, blue } -> #rrggbb
local function rgb_num2str(rgb_color_num)
  local rgb_color_str =
    string.format("#%02x%02x%02x", rgb_color_num.red, rgb_color_num.green, rgb_color_num.blue)
  return rgb_color_str
end

-- Returns brightness level of color in range 0 to 1
-- arbitrary value it's basically an weighted average
local function get_color_brightness(rgb_color)
  local color = rgb_str2num(rgb_color)
  local brightness = (color.red * 2 + color.green * 3 + color.blue) / 6
  return brightness / 256
end

-- returns average of colors in range 0 to 1
-- used to determine contrast level
local function get_color_avg(rgb_color)
  local color = rgb_str2num(rgb_color)
  return (color.red + color.green + color.blue) / 3 / 256
end

-- Clamps the val between left and right
local function clamp(val, left, right)
  if val > right then
    return right
  end
  if val < left then
    return left
  end
  return val
end

-- Changes brightness of rgb_color by percentage
local function brightness_modifier(rgb_color, percentage)
  local color = rgb_str2num(rgb_color)
  color.red = clamp(color.red + (color.red * percentage / 100), 0, 255)
  color.green = clamp(color.green + (color.green * percentage / 100), 0, 255)
  color.blue = clamp(color.blue + (color.blue * percentage / 100), 0, 255)
  return rgb_num2str(color)
end

-- Changes contrast of rgb_color by amount
local function contrast_modifier(rgb_color, amount)
  local color = rgb_str2num(rgb_color)
  color.red = clamp(color.red + amount, 0, 255)
  color.green = clamp(color.green + amount, 0, 255)
  color.blue = clamp(color.blue + amount, 0, 255)
  return rgb_num2str(color)
end

-- Changes brightness of foreground color to achieve contrast
-- without changing the color
local function apply_contrast(highlight)
  local highlight_bg_avg = get_color_avg(highlight.bg)
  local contrast_threshold_config = clamp(contrast_threshold, 0, 0.5)
  local contrast_change_step = 5
  if highlight_bg_avg > 0.5 then
    contrast_change_step = -contrast_change_step
  end

  -- Don't waste too much time here max 25 iteration should be more than enough
  local iteration_count = 1
  while
    math.abs(get_color_avg(highlight.fg) - highlight_bg_avg) < contrast_threshold_config
    and iteration_count < 25
  do
    highlight.fg = contrast_modifier(highlight.fg, contrast_change_step)
    iteration_count = iteration_count + 1
  end
end

-- lualine auto-theme utils }

-- Convert RGB color code into HSL color object.
local function rgb_to_hsl(rgb)
  local h, s, l = color_hsl.rgb_string_to_hsl(rgb)
  return color_hsl.new(h, s, l, rgb)
end

-- Darker/lighter RGB color code with a 0.0 ~ 1.0 parameter.
--
--- @param rgb string The RGB color code.
--- @param value number The 0.0 ~ 1.0 parameter.
local function shade_rgb(rgb, value)
  if vim.o.background == "light" then
    return rgb_to_hsl(rgb):tint(value):to_rgb()
  else
    return rgb_to_hsl(rgb):shade(value):to_rgb()
  end
end

---@return table
local function setup_common_colors()
  -- diagnostics
  local diagnostic_error =
    color_hl.get_color_with_fallback({ "DiagnosticSignError", "ErrorMsg" }, "fg", red)
  local diagnostic_warn =
    color_hl.get_color_with_fallback({ "DiagnosticSignWarn", "WarningMsg" }, "fg", yellow)
  local diagnostic_info =
    color_hl.get_color_with_fallback({ "DiagnosticSignInfo", "None" }, "fg", cyan)
  local diagnostic_hint =
    color_hl.get_color_with_fallback({ "DiagnosticSignHint", "Comment" }, "fg", grey)

  -- git diff
  local git_add = color_hl.get_color_with_fallback(
    { "GitSignsAdd", "GitGutterAdd", "diffAdded", "DiffAdd" },
    "fg",
    green
  )
  local git_change = color_hl.get_color_with_fallback(
    { "GitSignsChange", "GitGutterChange", "diffChanged", "DiffChange" },
    "fg",
    yellow
  )
  local git_delete = color_hl.get_color_with_fallback(
    { "GitSignsDelete", "GitGutterDelete", "diffRemoved", "DiffDelete" },
    "fg",
    red
  )

  -- git summary
  local git_ahead = get_terminal_color(3, yellow)
  local git_behind = get_terminal_color(3, yellow)
  local git_dirty = get_terminal_color(1, magenta)

  return {
    diagnostic_error = diagnostic_error,
    diagnostic_warn = diagnostic_warn,
    diagnostic_info = diagnostic_info,
    diagnostic_hint = diagnostic_hint,
    git_add = git_add,
    git_change = git_change,
    git_delete = git_delete,
    git_ahead = git_ahead,
    git_behind = git_behind,
    git_dirty = git_dirty,
  }
end

---@param lualine_theme table
---@return table<string, string>
local function setup_colors_from_lualine(lualine_theme)
  assert(type(lualine_theme) == "table")

  local shade_level1 = 0.3
  -- local shade_level2 = 0.5
  -- local shade_level3 = 0.7

  local normal_bg1 = lualine_theme.normal.a.bg
  local normal_fg1 = lualine_theme.normal.a.fg
  local normal_bg2 = lualine_theme.normal.b.bg
  local normal_fg2 = lualine_theme.normal.b.fg
  local normal_bg3 = shade_rgb(normal_bg2, shade_level1)
  local normal_fg3 = normal_fg2
  local normal_bg4 = lualine_theme.normal.c.bg
  local normal_fg4 = lualine_theme.normal.c.fg
  local insert_bg = lualine_theme.insert.a.bg
  local insert_fg = lualine_theme.insert.a.fg
  local visual_bg = lualine_theme.visual.a.bg
  local visual_fg = lualine_theme.visual.a.fg
  local replace_bg = lualine_theme.replace.a.bg
  local replace_fg = lualine_theme.replace.a.fg
  local command_bg = lualine_theme.command.a.bg
  local command_fg = lualine_theme.command.a.fg

  return {
    normal_bg1 = normal_bg1,
    normal_fg1 = normal_fg1,
    normal_bg2 = normal_bg2,
    normal_fg2 = normal_fg2,
    normal_bg3 = normal_bg3,
    normal_fg3 = normal_fg3,
    normal_bg4 = normal_bg4,
    normal_fg4 = normal_fg4,
    insert_bg = insert_bg,
    insert_fg = insert_fg,
    visual_bg = visual_bg,
    visual_fg = visual_fg,
    replace_bg = replace_bg,
    replace_fg = replace_fg,
    command_bg = command_bg,
    command_fg = command_fg,
  }
end

---@param airline_theme table
---@return table<string, string>
local function setup_colors_from_airline(airline_theme)
  assert(type(airline_theme) == "table")

  local shade_level1 = 0.3
  -- local shade_level2 = 0.5
  -- local shade_level3 = 0.7

  local normal_bg1 = airline_theme.normal.airline_a[2]
  local normal_fg1 = airline_theme.normal.airline_a[1]
  local normal_bg2 = airline_theme.normal.airline_b[2]
  local normal_fg2 = airline_theme.normal.airline_b[1]
  local normal_bg3 = shade_rgb(normal_bg2, shade_level1)
  local normal_fg3 = normal_fg2
  local normal_bg4 = airline_theme.normal.airline_c[2]
  local normal_fg4 = airline_theme.normal.airline_c[1]
  local insert_bg = airline_theme.insert.airline_a[2]
  local insert_fg = airline_theme.insert.airline_a[1]
  local visual_bg = airline_theme.visual.airline_a[2]
  local visual_fg = airline_theme.visual.airline_a[1]
  local replace_bg = airline_theme.replace.airline_a[2]
  local replace_fg = airline_theme.replace.airline_a[1]
  local command_bg = airline_theme.terminal.airline_a[2]
  local command_fg = airline_theme.terminal.airline_a[1]

  return {
    normal_bg1 = normal_bg1,
    normal_fg1 = normal_fg1,
    normal_bg2 = normal_bg2,
    normal_fg2 = normal_fg2,
    normal_bg3 = normal_bg3,
    normal_fg3 = normal_fg3,
    normal_bg4 = normal_bg4,
    normal_fg4 = normal_fg4,
    insert_bg = insert_bg,
    insert_fg = insert_fg,
    visual_bg = visual_bg,
    visual_fg = visual_fg,
    replace_bg = replace_bg,
    replace_fg = replace_fg,
    command_bg = command_bg,
    command_fg = command_fg,
  }
end

---@param colorname string?
---@return table<string, string>
local function setup_colors_from_auto_generating(colorname)
  -- Lualine auto theme
  -- See: https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/themes/auto.lua
  local colors = {
    normal = color_hl.get_color_with_fallback(
      { "PmenuSel", "PmenuThumb", "TabLineSel" },
      "bg",
      black
    ),
    insert = color_hl.get_color_with_fallback({ "String", "MoreMsg" }, "fg", black),
    replace = color_hl.get_color_with_fallback({ "Number", "Type" }, "fg", black),
    visual = color_hl.get_color_with_fallback({ "Special", "Boolean", "Constant" }, "fg", black),
    command = color_hl.get_color_with_fallback({ "Identifier" }, "fg", black),
    back1 = color_hl.get_color_with_fallback({ "Normal", "StatusLineNC" }, "bg", black),
    fore = color_hl.get_color_with_fallback({ "Normal", "StatusLine" }, "fg", black),
    back2 = color_hl.get_color_with_fallback({ "StatusLine" }, "bg", black),
  }

  local normal_color = color_hl.get_color_with_fallback({ "Normal" }, "bg", black)
  if normal_color ~= nil then
    if get_color_brightness(normal_color) > 0.5 then
      brightness_modifier_parameter = -brightness_modifier_parameter
    end
    for name, color in pairs(colors) do
      colors[name] = brightness_modifier(color, brightness_modifier_parameter)
    end
  end

  local lualine_auto_theme = {
    normal = {
      a = { bg = colors.normal, fg = colors.back1, gui = "bold" },
      b = { bg = colors.back1, fg = colors.normal },
      c = { bg = colors.back2, fg = colors.fore },
    },
    insert = {
      a = { bg = colors.insert, fg = colors.back1, gui = "bold" },
      b = { bg = colors.back1, fg = colors.insert },
      c = { bg = colors.back2, fg = colors.fore },
    },
    replace = {
      a = { bg = colors.replace, fg = colors.back1, gui = "bold" },
      b = { bg = colors.back1, fg = colors.replace },
      c = { bg = colors.back2, fg = colors.fore },
    },
    visual = {
      a = { bg = colors.visual, fg = colors.back1, gui = "bold" },
      b = { bg = colors.back1, fg = colors.visual },
      c = { bg = colors.back2, fg = colors.fore },
    },
    command = {
      a = { bg = colors.command, fg = colors.back1, gui = "bold" },
      b = { bg = colors.back1, fg = colors.command },
      c = { bg = colors.back2, fg = colors.fore },
    },
  }

  lualine_auto_theme.terminal = lualine_auto_theme.command
  lualine_auto_theme.inactive = lualine_auto_theme.normal

  for _, section in pairs(lualine_auto_theme) do
    for _, highlight in pairs(section) do
      apply_contrast(highlight)
    end
  end

  return setup_colors_from_lualine(lualine_auto_theme)
end

---@param colorname string?
---@return table<string, string>
local function setup_colors(colorname)
  -- If current colorscheme provides a lualine theme.
  local has_lualine, lualine_theme = pcall(require, string.format("lualine.themes.%s", colorname))

  -- If current colorscheme provides a airline theme.
  local has_airline, airline_theme
  if not has_lualine or type(lualine_theme) ~= "table" then
    local airline_theme_name = string.format("airline#themes#%s#palette", colorname)
    has_airline = vim.fn.exists("g:" .. airline_theme_name) > 0
    if has_airline then
      vim.cmd("let heirline_tmp=g:" .. airline_theme_name)
      airline_theme = vim.g[airline_theme_name]
    end
  end

  local colors
  if has_lualine and type(lualine_theme) == "table" then
    colors = setup_colors_from_lualine(lualine_theme)
  elseif has_airline and type(airline_theme) == "table" then
    colors = setup_colors_from_airline(airline_theme)
  else
    colors = setup_colors_from_auto_generating(colorname)
  end

  local common_colors = setup_common_colors()
  return vim.tbl_extend("force", common_colors, colors)
end

require("heirline").setup({
  statusline = StatusLine,
  opts = {
    colors = setup_colors(vim.g.colors_name),
  },
})

local heirline_augroup = vim.api.nvim_create_augroup("heirline_augroup", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = heirline_augroup,
  callback = function(event)
    local colorname = event.match
    require("heirline.utils").on_colorscheme(setup_colors(colorname))
  end,
})
vim.api.nvim_create_autocmd("VimEnter", {
  group = heirline_augroup,
  callback = function()
    local colorname = vim.g.colors_name
    require("heirline.utils").on_colorscheme(setup_colors(colorname))
  end,
})

-- When current buffer is a file, get its directory.
--- @return string?
local function get_buffer_dir()
  local bufnr = vim.api.nvim_get_current_buf()
  if type(bufnr) == "number" and bufnr > 0 then
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if type(bufname) == "string" and string.len(bufname) > 0 then
      local bufdir = vim.fn.fnamemodify(bufname, ":h")
      if type(bufdir) == "string" and string.len(bufdir) > 0 and vim.fn.isdirectory(bufdir) > 0 then
        return bufdir
      end
    end
  end

  return nil
end

-- Parse the output lines of `git status -b --porcelain=v2`.
-- Get the branch name, ahead count, behind count, and if changed.
--
--- @param status_lines string[]
--- @return {branch:string?,ahead:integer?,behind:integer?,changed:boolean?}?
local function parse_git_status(status_lines)
  local result = {}
  for _, line in ipairs(status_lines) do
    if str.startswith(line, "# branch.head") then
      local branch_name = string.sub(line, 14)
      result["branch"] = str.trim(branch_name)
    end
    if str.startswith(line, "# branch.ab") then
      local ab_splits = str.split(line, " ", { trimempty = true })
      if tbl.list_not_empty(ab_splits) then
        for _, ab in ipairs(ab_splits) do
          if str.startswith(ab, "+") and string.len(ab) > 1 then
            local a_count = tonumber(string.sub(ab, 2))
            if type(a_count) == "number" and a_count > 0 then
              result["ahead"] = a_count
            end
          end
          if str.startswith(ab, "-") and string.len(ab) > 1 then
            local b_count = tonumber(string.sub(ab, 2))
            if type(b_count) == "number" and b_count > 0 then
              result["behind"] = b_count
            end
          end
        end
      end
    end
    if not str.startswith(line, "# branch") then
      local changed_splits = str.split(line, " ", { plain = true, trimempty = true })
      if tbl.list_not_empty(changed_splits) and tonumber(changed_splits[1]) ~= nil then
        result["changed"] = true
      end
    end
  end

  if tbl.tbl_not_empty(result) then
    return result
  else
    return nil
  end
end

local updating_git_branch = false

local function update_git_branch()
  if updating_git_branch then
    return
  end
  updating_git_branch = true

  local cwd = get_buffer_dir()
  local status_info = {}
  local failed_get_status = false
  spawn.run({ "git", "-c", "color.status=never", "status", "-b", "--porcelain=v2" }, {
    cwd = cwd,
    on_stdout = function(line)
      if type(line) == "string" then
        table.insert(status_info, line)
      end
    end,
    on_stderr = function()
      status_info = nil
    end,
  }, function(completed)
    if
      not failed_get_status
      and tbl.tbl_get(completed, "code") == 0
      and tbl.list_not_empty(status_info)
    then
      local branch_status = parse_git_status(status_info)

      if
        type(branch_status) == "table"
        and type(branch_status.branch) == "string"
        and string.len(branch_status.branch) > 0
      then
        git_branch_name_cache = branch_status.branch
      end

      if tbl.tbl_not_empty(branch_status) then
        git_branch_status_cache = branch_status
      else
        git_branch_status_cache = nil
      end
    end
    vim.schedule(function()
      vim.api.nvim_exec_autocmds("User", {
        pattern = "HeirlineGitBranchUpdated",
        modeline = false,
      })
      vim.schedule(function()
        updating_git_branch = false
      end)
    end)
  end)
end

vim.api.nvim_create_autocmd(
  { "FocusGained", "FocusLost", "TermLeave", "TermClose", "DirChanged", "BufEnter", "VimEnter" },
  {
    group = heirline_augroup,
    callback = update_git_branch,
  }
)
