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
  Progress,
}

-- Get RGB color code from either lualine/airline theme, or fallback to highlighting group, or fallback to default color.
-- A lualine/airline theme usually contains several components:
-- 1. It supports different color on different VIM mode, i.e. it shows different colors on normal/visual/insert/etc modes.
-- 2. It supports 3 color on 3 sections, i.e. the most left/right side, the most center part, and the other two parts between them.
--
---@param has_lualine boolean If have a lualine theme.
---@param lualine_theme table The lualine theme.
---@param has_airline boolean If have an airline theme.
---@param airline_theme table The airline theme.
---@param mode_name "normal"|"insert"|"visual"|"replace"|"command"|"inactive" Mode name that use to retrieve from lualine/airline.
---@param section "a"|"b"|"c" Section name that use to retrieve from lualine/airline.
---@param attribute "fg"|"bg" Foreground/background attribute that use to retrieve from lualine/airline.
---@param fallback_hls string|string[] Fallback highlighting groups.
---@param fallback_attribute "fg"|"bg" Fallback foreground/background attribute that use to retrieve from the highlighting groups.
---@param fallback_color string? Fallback default color, if none of lualine/airline themes and highlighting groups exists.
---@return string, "lualine"|"airline"|"fallback"
local function retrieve_color(
  has_lualine,
  lualine_theme,
  has_airline,
  airline_theme,
  mode_name,
  section,
  attribute,
  fallback_hls,
  fallback_attribute,
  fallback_color
)
  local air_section = "airline_" .. section
  local air_attribute = attribute == "fg" and 1 or 2
  local air_mode_name = mode_name == "command" and "terminal" or mode_name

  --- @type string
  local result
  --- @type "lualine"|"airline"|"fallback"
  local source

  if has_lualine and tbl.tbl_get(lualine_theme, mode_name, section, attribute) then
    result = lualine_theme[mode_name][section][attribute]
    source = "lualine"
  elseif has_airline and tbl.tbl_get(airline_theme, air_mode_name, air_section, air_attribute) then
    result = airline_theme[air_mode_name][air_section][air_attribute]
    source = "airline"
  end

  if type(result) ~= "string" then
    result = color_hl.get_color_with_fallback(fallback_hls, fallback_attribute, fallback_color) --[[@as string]]
    source = "fallback"
  end

  return result, source
end

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

-- Turns #rrggbb -> { red, green, blue }
local function rgb_str2num(rgb_color_str)
  if rgb_color_str:find("#") == 1 then
    rgb_color_str = rgb_color_str:sub(2, #rgb_color_str)
  end
  local r = tonumber(rgb_color_str:sub(1, 2), 16)
  local g = tonumber(rgb_color_str:sub(3, 4), 16)
  local b = tonumber(rgb_color_str:sub(5, 6), 16)
  return { red = r, green = g, blue = b }
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

---@param colorname string?
---@return table<string, string>
local function setup_colors(colorname)
  local shade_level1 = 0.3
  local shade_level2 = 0.5
  local shade_level3 = 0.7

  local diagnostic_error =
    color_hl.get_color_with_fallback({ "DiagnosticSignError", "ErrorMsg" }, "fg", red)
  local diagnostic_warn =
    color_hl.get_color_with_fallback({ "DiagnosticSignWarn", "WarningMsg" }, "fg", yellow)
  local diagnostic_info =
    color_hl.get_color_with_fallback({ "DiagnosticSignInfo", "None" }, "fg", cyan)
  local diagnostic_hint =
    color_hl.get_color_with_fallback({ "DiagnosticSignHint", "Comment" }, "fg", grey)
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
  local git_ahead = get_terminal_color(3, yellow)
  local git_behind = get_terminal_color(3, yellow)
  local git_dirty = get_terminal_color(1, magenta)

  local text_bg, text_fg
  local normal_bg, normal_fg
  local normal_bg1, normal_fg1
  local normal_bg2, normal_fg2
  local normal_bg3, normal_fg3
  local normal_bg4, normal_fg4
  local insert_bg, insert_fg
  local visual_bg, visual_fg
  local replace_bg, replace_fg
  local command_bg, command_fg

  -- The `lualine` is the most popular statusline plugin in Neovim community.
  -- The `airline` is the one of the most popular statusline plugin in Vim community.
  -- Both of them provide a way to integrate with third-party colorschemes.
  --
  -- See:
  -- * [lualine doc - SETTING A THEME](https://github.com/nvim-lualine/lualine.nvim/blob/544dd1583f9bb27b393f598475c89809c4d5e86b/doc/lualine.txt#L178-L205)
  -- * [lualine wiki - Writing a theme](https://github.com/nvim-lualine/lualine.nvim/wiki/Writing-a-theme)
  -- * [airline doc - WRITING THEMES](https://github.com/vim-airline/vim-airline/blob/02894b6ef4752afd8579fc837aec5fb4f62409f7/doc/airline.txt#L2099-L2111)
  --
  -- So if a colorscheme provides either lualine or airline theme, let's directly use them.
  -- Since they're carefully designed by the author of the colorscheme.

  -- If current colorscheme provides a lualine theme.
  local has_lualine, lualine_theme = pcall(require, string.format("lualine.themes.%s", colorname))

  -- If current colorscheme provides an airline theme.
  local has_airline = false
  local airline_theme_name = string.format("airline#themes#%s#palette", colorname)
  local airline_theme = nil
  if not has_lualine and vim.fn.exists("g:" .. airline_theme_name) > 0 then
    has_airline = true
    vim.cmd("let heirline_tmp=g:" .. airline_theme_name)
    airline_theme = vim.g[airline_theme_name]
  end

  -- Retrieve RGB color from lualine/airline, or fallback to a highlighting group, or fallback to a default color.
  text_bg = retrieve_color(
    has_lualine,
    lualine_theme,
    has_airline,
    airline_theme,
    "normal",
    "a",
    "bg",
    { "Normal" },
    "bg",
    black
  )
  text_fg = retrieve_color(
    has_lualine,
    lualine_theme,
    has_airline,
    airline_theme,
    "normal",
    "a",
    "fg",
    { "Normal" },
    "fg",
    white
  )
  -- print(string.format("text bg/fg:%s/%s", vim.inspect(text_bg), vim.inspect(text_fg)))

  -- local normal_bg_derives = derive_rgb(get_terminal_color(0, magenta), 6)
  local normal_bg_source

  normal_bg, normal_bg_source = retrieve_color(
    has_lualine,
    lualine_theme,
    has_airline,
    airline_theme,
    "normal",
    "a",
    "bg",
    { "StatusLine", "PmenuSel", "PmenuThumb", "TabLineSel" },
    "bg",
    get_terminal_color(0, magenta)
  )
  normal_fg = retrieve_color(
    has_lualine,
    lualine_theme,
    has_airline,
    airline_theme,
    "normal",
    "a",
    "fg",
    {},
    "fg",
    text_bg -- or black
  )
  normal_bg1 = normal_bg
  normal_fg1 = normal_fg

  normal_bg2 = retrieve_color(
    has_lualine,
    lualine_theme,
    has_airline,
    airline_theme,
    "normal",
    "b",
    "bg",
    {},
    "bg",
    shade_rgb(get_terminal_color(0, magenta), shade_level1)
  )
  normal_fg2 = retrieve_color(
    has_lualine,
    lualine_theme,
    has_airline,
    airline_theme,
    "normal",
    "b",
    "fg",
    {},
    "fg",
    text_fg -- or white
  )
  normal_bg3 = retrieve_color(
    has_lualine,
    lualine_theme,
    has_airline,
    airline_theme,
    "normal",
    "c",
    "bg",
    {},
    "bg",
    shade_rgb(get_terminal_color(0, magenta), shade_level2)
  )
  normal_fg3 = retrieve_color(
    has_lualine,
    lualine_theme,
    has_airline,
    airline_theme,
    "normal",
    "c",
    "fg",
    {},
    "fg",
    text_fg -- or white
  )
  if normal_bg_source ~= "fallback" then
    normal_bg4 = shade_rgb(normal_bg3, shade_level1)
  else
    normal_bg4 = shade_rgb(get_terminal_color(0, magenta), shade_level3)
  end
  normal_fg4 = normal_fg3

  print(string.format("1-normal source:%s", vim.inspect(normal_bg_source)))

  insert_bg = retrieve_color(
    has_lualine,
    lualine_theme,
    has_airline,
    airline_theme,
    "insert",
    "a",
    "bg",
    { "String", "MoreMsg" },
    "fg",
    get_terminal_color(2, green)
  )
  insert_fg = retrieve_color(
    has_lualine,
    lualine_theme,
    has_airline,
    airline_theme,
    "insert",
    "a",
    "fg",
    {},
    "fg",
    text_bg
  )
  visual_bg = retrieve_color(
    has_lualine,
    lualine_theme,
    has_airline,
    airline_theme,
    "visual",
    "a",
    "bg",
    { "Special", "Boolean", "Constant" },
    "fg",
    get_terminal_color(3, yellow)
  )
  visual_fg = retrieve_color(
    has_lualine,
    lualine_theme,
    has_airline,
    airline_theme,
    "visual",
    "a",
    "fg",
    {},
    "fg",
    text_bg
  )
  replace_bg = retrieve_color(
    has_lualine,
    lualine_theme,
    has_airline,
    airline_theme,
    "replace",
    "a",
    "bg",
    { "Number", "Type" },
    "fg",
    get_terminal_color(4, blue)
  )
  replace_fg = retrieve_color(
    has_lualine,
    lualine_theme,
    has_airline,
    airline_theme,
    "replace",
    "a",
    "fg",
    {},
    "fg",
    text_bg
  )
  command_bg = retrieve_color(
    has_lualine,
    lualine_theme,
    has_airline,
    airline_theme,
    "command",
    "a",
    "bg",
    { "Identifier" },
    "fg",
    get_terminal_color(1, red)
  )
  command_fg = retrieve_color(
    has_lualine,
    lualine_theme,
    has_airline,
    airline_theme,
    "command",
    "a",
    "fg",
    {},
    "fg",
    text_bg
  )
  -- print(string.format("1-text bg/fg:%s/%s", vim.inspect(text_bg), vim.inspect(text_fg)))

  if not has_lualine and not has_airline then
    local background_color = color_hl.get_color("Normal", "bg")
    if background_color then
      local parameter = get_color_brightness(background_color) > 0.5 and -10 or 10
      normal_bg = brightness_modifier(normal_bg, parameter)
      normal_bg1 = normal_bg
      if get_color_brightness(normal_bg1) < 0.5 then
        normal_fg = text_fg
        normal_fg1 = text_fg
      end

      -- local normal_bg_derives2 = derive_rgb(normal_bg1, 6)
      -- print(
      --   string.format(
      --     "2-normal source:%s, derives2:%s",
      --     vim.inspect(normal_bg_source),
      --     vim.inspect(normal_bg_derives2)
      --   )
      -- )
      -- print(string.format("normal bg derives2:%s", vim.inspect(normal_bg_derives2)))
      normal_bg2 = shade_rgb(normal_bg, shade_level1)
      if get_color_brightness(normal_bg2) > 0.5 then
        normal_fg2 = text_bg
      end
      normal_bg3 = shade_rgb(normal_bg, shade_level2)
      if get_color_brightness(normal_bg3) > 0.5 then
        normal_fg3 = text_bg
      end
      normal_bg4 = shade_rgb(normal_bg, shade_level3)
      if get_color_brightness(normal_bg4) > 0.5 then
        normal_fg4 = text_bg
      end
      -- print(string.format("2-text bg/fg:%s/%s", vim.inspect(text_bg), vim.inspect(text_fg)))
      -- print(
      --   string.format(
      --     "text bg/fg:%s/%s, normal bg1/fg1:%s/%s,bg2/fg2:%s/%s,bg3/fg3:%s/%s,bg4/fg4:%s/%s",
      --     vim.inspect(text_bg),
      --     vim.inspect(text_fg),
      --     vim.inspect(normal_bg1),
      --     vim.inspect(normal_fg1),
      --     vim.inspect(normal_bg2),
      --     vim.inspect(normal_fg2),
      --     vim.inspect(normal_bg3),
      --     vim.inspect(normal_fg3),
      --     vim.inspect(normal_bg4),
      --     vim.inspect(normal_fg4)
      --   )
      -- )

      -- normal_bg2 = shade_rgb(normal_bg, 0.5)
      -- if get_color_brightness(normal_bg2) > 0.5 then
      --   normal_fg2 = text_bg
      -- end
      -- normal_bg3 = shade_rgb(normal_bg, shade_level2)
      -- if get_color_brightness(normal_bg3) > 0.5 then
      --   normal_fg3 = text_bg
      -- end
      -- normal_bg4 = shade_rgb(normal_bg, shade_level3)
      -- if get_color_brightness(normal_bg4) > 0.5 then
      --   normal_fg4 = text_bg
      -- end

      insert_bg = brightness_modifier(insert_bg, parameter)
      if get_color_brightness(insert_bg) < 0.5 then
        insert_fg = text_fg
      end
      visual_bg = brightness_modifier(visual_bg, parameter)
      if get_color_brightness(visual_bg) < 0.5 then
        visual_fg = text_fg
      end
      replace_bg = brightness_modifier(replace_bg, parameter)
      if get_color_brightness(replace_bg) < 0.5 then
        replace_fg = text_fg
      end
      command_bg = brightness_modifier(command_bg, parameter)
      if get_color_brightness(command_bg) < 0.5 then
        command_fg = text_fg
      end
    end
  end

  return {
    text_bg = text_bg,
    text_fg = text_fg,
    black = black,
    white = white,
    red = red,
    green = green,
    blue = blue,
    cyan = cyan,
    grey = grey,
    orange = orange,
    yellow = yellow,
    purple = purple,
    magenta = magenta,
    bright_black = bright_black,
    bright_red = bright_red,
    bright_green = bright_green,
    bright_yellow = bright_yellow,
    bright_blue = bright_blue,
    bright_magenta = bright_magenta,
    bright_cyan = bright_cyan,
    bright_white = bright_white,
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
