local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local uv = require("commons.uv")
local strings = require("commons.strings")
local tables = require("commons.tables")
local colors_hl = require("commons.colors.hl")
local colors_hsl = require("commons.colors.hsl")

local constants = require("builtin.utils.constants")

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

local left_slant = ""
local right_slant = ""

local function rgb_to_hsl(rgb)
    local h, s, l = colors_hsl.rgb_string_to_hsl(rgb)
    return colors_hsl.new(h, s, l, rgb)
end

-- value 1-100
local function shade_rgb(rgb, value)
    if vim.o.background == "light" then
        return rgb_to_hsl(rgb):tint(value):to_rgb()
    end
    return rgb_to_hsl(rgb):shade(value):to_rgb()
end

local OS_UNAME = uv.os_uname()

local function GetOsIcon()
    local uname = OS_UNAME.sysname
    if uname:match("Darwin") then
        return ""
    elseif uname:match("Windows") then
        return ""
    elseif uname:match("Linux") then
        if
            type(OS_UNAME.release) == "string"
            and OS_UNAME.release:find("arch")
        then
            return ""
        end
        return ""
    else
        return "󱚟"
    end
end

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

local Mode = {
    init = function(self)
        self.mode = vim.fn.mode(1)
    end,
    hl = function(self)
        local mode_name = GetModeName(self.mode)
        local mode_hl = ModeHighlights[mode_name] or ModeHighlights.NORMAL
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
            local mode_name = GetModeName(self.mode)
            local mode_hl = ModeHighlights[mode_name] or ModeHighlights.NORMAL
            return { fg = mode_hl.bg, bg = "normal_bg2" }
        end,
    },
}

local GitBranch = {
    hl = { fg = "normal_fg2", bg = "normal_bg2" },
    update = { "BufEnter", "BufReadPre", "BufNewFile" },

    {
        provider = function(self)
            if vim.fn.exists("*gitbranch#name") > 0 then
                local branch = vim.fn["gitbranch#name"]()
                if strings.not_empty(branch) then
                    return "  " .. branch .. " "
                end
            end
            return ""
        end,
        update = { "User", pattern = "VeryLazy" },
    },
    {
        provider = right_slant,
        hl = { fg = "normal_bg2", bg = "normal_bg3" },
    },
}

local FileName = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,
    hl = { fg = "normal_fg3", bg = "normal_bg3" },

    -- file name
    {
        provider = function(self)
            if strings.empty(self.filename) then
                return ""
            end
            local fname = vim.fn.fnamemodify(self.filename, ":t")
            if strings.empty(fname) then
                return ""
            end
            return " " .. fname .. " "
        end,
        update = {
            "BufEnter",
            "BufNewFile",
            "WinEnter",
        },
    },
    -- file status
    {
        provider = function(self)
            if strings.empty(self.filename) then
                return ""
            end
            local readonly = not vim.api.nvim_buf_get_option(
                    0,
                    "modifiable"
                )
                or vim.api.nvim_buf_get_option(0, "readonly")
            if readonly then
                return "[] "
            end
            local modified = vim.api.nvim_buf_get_option(0, "modified")
            if modified then
                return "[] "
            end
            return ""
        end,
        update = {
            "TextChangedI",
            "BufWritePost",
            "BufEnter",
            "BufNewFile",
            "WinEnter",
        },
    },
    -- file size
    {
        provider = function(self)
            if strings.empty(self.filename) then
                return ""
            end
            local filesize = vim.fn.getfsize(self.filename)
            if type(filesize) ~= "number" or filesize <= 0 then
                return ""
            end
            local suffixes = { "b", "k", "m", "g" }
            local i = 1
            while filesize > 1024 and i < #suffixes do
                filesize = filesize / 1024
                i = i + 1
            end

            local fsize_fmt = i == 1 and "[%d%s] " or "[%.1f%s] "
            local fsize_value = string.format(fsize_fmt, filesize, suffixes[i])
            return fsize_value
        end,
        update = {
            "BufWritePost",
            "BufEnter",
            "BufNewFile",
            "WinEnter",
        },
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
    update = { "BufEnter", "BufReadPre", "BufNewFile" },
    hl = { fg = "normal_fg4", bg = "normal_bg4" },
    update = { "User", pattern = "GitGutter" },

    {
        provider = function(self)
            local value = self.summary[1] or 0
            if value > 0 then
                return string.format(" +%d", value)
            end
            return ""
        end,
        hl = { fg = "git_add", bg = "normal_bg4" },
    },
    {
        provider = function(self)
            local value = self.summary[2] or 0
            if value > 0 then
                return string.format(" ~%d", value)
            end
            return ""
        end,
        hl = { fg = "git_change", bg = "normal_bg4" },
    },
    {
        provider = function(self)
            local value = self.summary[3] or 0
            if value > 0 then
                return string.format(" -%d", value)
            end
            return ""
        end,
        hl = { fg = "git_delete", bg = "normal_bg4" },
    },
}

local LspStatus = {
    hl = { fg = "normal_fg4", bg = "normal_bg4" },
    provider = function()
        local result = require("lsp-progress").progress({ max_size = 100 })
        if strings.not_empty(result) then
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
    provider = function(self)
        if vim.v.hlsearch == 0 then
            return ""
        end
        local ok, result =
            pcall(vim.fn.searchcount, { maxcount = 100, timeout = 500 })
        if not ok or tables.tbl_empty(result) then
            return ""
        end
        local denominator = math.min(result.total, result.maxcount)
        return string.format("[%d/%d] ", result.current, denominator)
    end,
    update = { "SearchWrapped", "CursorMoved" },
}

local DiagnosticSigns = {
    constants.diagnostic.sign.error,
    constants.diagnostic.sign.warning,
    constants.diagnostic.sign.info,
    constants.diagnostic.sign.hint,
}
local DiagnosticColors = {
    "diagnostic_error",
    "diagnostic_warn",
    "diagnostic_info",
    "diagnostic_hint",
}
local DiagnosticSeverity = { "ERROR", "WARN", "INFO", "HINT" }

local function GetDiagnosticText(level)
    local value = #vim.diagnostic.get(
        0,
        { severity = vim.diagnostic.severity[DiagnosticSeverity[level]] }
    )
    if value <= 0 then
        return ""
    end
    return string.format("%s %d ", DiagnosticSigns[level], value)
end

local function GetDiagnosticHighlight(level)
    return { fg = DiagnosticColors[level], bg = "normal_bg4" }
end

local Diagnostic = {
    hl = { fg = "normal_fg4", bg = "normal_bg4" },
    update = { "DiagnosticChanged", "BufEnter", "BufWritePost" },

    {
        provider = function(self)
            return GetDiagnosticText(1)
        end,
        hl = GetDiagnosticHighlight(1),
    },
    {
        provider = function(self)
            return GetDiagnosticText(2)
        end,
        hl = GetDiagnosticHighlight(2),
    },
    {
        provider = function(self)
            return GetDiagnosticText(3)
        end,
        hl = GetDiagnosticHighlight(3),
    },
    {
        provider = function(self)
            return GetDiagnosticText(4)
        end,
        hl = GetDiagnosticHighlight(4),
    },
}

local FileType = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0) or ""
        self.filename_ext = vim.fn.fnamemodify(self.filename, ":e") or ""
        self.devicons = require("nvim-web-devicons")
    end,
    hl = { fg = "normal_fg3", bg = "normal_bg3" },

    {
        provider = left_slant,
        hl = { fg = "normal_bg3", bg = "normal_bg4" },
    },
    {
        provider = function(self)
            if strings.empty(self.filename_ext) then
                return ""
            end
            local icon_text, icon_color =
                self.devicons.get_icon_color(self.filename, self.filename_ext)
            if strings.not_empty(icon_text) then
                return " " .. icon_text .. " "
            else
                return "  "
            end
        end,
        hl = function(self)
            local icon_text, icon_color =
                self.devicons.get_icon_color(self.filename, self.filename_ext)
            if strings.not_empty(icon_color) then
                return { fg = icon_color, bg = "normal_bg3" }
            else
                return { fg = "normal_fg3", bg = "normal_bg3" }
            end
        end,
        update = {
            "BufEnter",
            "BufNewFile",
            "WinEnter",
        },
    },
    {
        provider = function(self)
            if strings.empty(self.filename_ext) then
                return ""
            end
            return self.filename_ext .. " "
        end,
        update = {
            "BufEnter",
            "BufNewFile",
            "WinEnter",
        },
    },
    {
        provider = left_slant,
        hl = { fg = "normal_bg2", bg = "normal_bg3" },
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
    hl = { fg = "normal_fg2", bg = "normal_bg2" },
    provider = function(self)
        local text = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
        if strings.empty(text) then
            return ""
        end
        local icon = FileEncodingIcons[text]
        if strings.empty(icon) then
            return " " .. text
        end
        return " " .. icon .. " " .. text
    end,
    update = {
        "BufEnter",
        "BufNewFile",
        "BufWritePost",
        "WinEnter",
    },
}

local FileFormatIcons = {
    unix = " LF", -- e712
    dos = " CRLF", -- e70f
    mac = " CR", -- e711
}

local FileFormat = {
    hl = { fg = "normal_fg2", bg = "normal_bg2" },

    {
        provider = function(self)
            local text = vim.bo.fileformat
            if strings.empty(text) then
                return ""
            end
            local icon = FileFormatIcons[text]
            if strings.empty(icon) then
                return " " .. text .. " "
            end
            return " " .. icon .. " "
        end,
        update = {
            "BufEnter",
            "BufNewFile",
            "BufWritePost",
            "WinEnter",
        },
    },
    {
        provider = left_slant,
        hl = { fg = "normal_fg1", bg = "normal_bg2" },
    },
}

local Location = {
    init = function(self)
        self.mode = vim.fn.mode(1)
    end,
    hl = function(self)
        local mode_name = GetModeName(self.mode)
        local mode_hl = ModeHighlights[mode_name] or ModeHighlights.NORMAL
        return { fg = mode_hl.fg, bg = mode_hl.bg, bold = true }
    end,

    {
        provider = left_slant,
    },
    {
        provider = function(self)
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            if type(row) ~= "number" or type(col) ~= "number" then
                return ""
            end
            return "  " .. string.format("%3s:%2s", row, col + 1)
        end,
    },
}

local Progress = {
    init = function(self)
        self.mode = vim.fn.mode(1)
    end,
    hl = function(self)
        local mode_name = GetModeName(self.mode)
        local mode_hl = ModeHighlights[mode_name] or ModeHighlights.NORMAL
        return { fg = mode_hl.fg, bg = mode_hl.bg, bold = true }
    end,
    provider = function(self)
        local line_fraction =
            math.floor(vim.fn.line(".") / vim.fn.line("$") * 100)
        local value = string.format("%3d%%%%", line_fraction)
        if line_fraction <= 0 then
            value = "Top"
        elseif line_fraction >= 100 then
            value = "Bot"
        end
        return "  " .. value
    end,
}

local StatusLine = {
    Mode,
    GitBranch,
    FileName,
    GitDiff,
    LspStatus,
    { provider = "%=", hl = { fg = "normal_fg4", bg = "normal_bg4" } },
    SearchCount,
    Diagnostic,
    FileType,
    FileEncoding,
    FileFormat,
    Location,
    Progress,
}

---@param lualine_ok boolean
---@param lualine_theme table
---@param mode_name "normal"|"insert"|"visual"|"replace"|"command"|"inactive"
---@param section "a"|"b"|"c"
---@param attribute "fg"|"bg"
---@param fallback_hls string|string[]
---@param fallback_attribute 'fg'|'bg'
---@param fallback_color string?
local function get_color_with_lualine(
    lualine_ok,
    lualine_theme,
    mode_name,
    section,
    attribute,
    fallback_hls,
    fallback_attribute,
    fallback_color
)
    if
        lualine_ok
        and tables.tbl_get(lualine_theme, mode_name, section, attribute)
    then
        return lualine_theme[mode_name][section][attribute]
    else
        return colors_hl.get_color_with_fallback(
            fallback_hls,
            fallback_attribute,
            fallback_color
        )
    end
end

local function get_terminal_color_with_fallback(number, fallback)
    if strings.not_empty(vim.g[string.format("terminal_color_%d", number)]) then
        return vim.g[string.format("terminal_color_%d", number)]
    else
        return fallback
    end
end

---@param colorname string?
---@return table<string, string>
local function setup_colors(colorname)
    local diagnostic_error = colors_hl.get_color_with_fallback(
        { "DiagnosticSignError", "ErrorMsg" },
        "fg",
        red
    )
    local diagnostic_warn = colors_hl.get_color_with_fallback(
        { "DiagnosticSignWarn", "WarningMsg" },
        "fg",
        yellow
    )
    local diagnostic_info = colors_hl.get_color_with_fallback(
        { "DiagnosticSignInfo", "None" },
        "fg",
        cyan
    )
    local diagnostic_hint = colors_hl.get_color_with_fallback(
        { "DiagnosticSignHint", "Comment" },
        "fg",
        grey
    )
    local git_add = colors_hl.get_color_with_fallback(
        { "GitSignsAdd", "GitGutterAdd", "diffAdded", "DiffAdd" },
        "fg",
        green
    )
    local git_change = colors_hl.get_color_with_fallback(
        { "GitSignsChange", "GitGutterChange", "diffChanged", "DiffChange" },
        "fg",
        yellow
    )
    local git_delete = colors_hl.get_color_with_fallback(
        { "GitSignsDelete", "GitGutterDelete", "diffRemoved", "DiffDelete" },
        "fg",
        red
    )

    local lualine_ok, lualine_theme =
        pcall(require, string.format("lualine.themes.%s", colorname))
    local text_bg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "a",
        "bg",
        { "Normal" },
        "bg",
        black
    )
    local text_fg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "a",
        "fg",
        { "Normal" },
        "fg",
        white
    )
    local statusline_bg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "c",
        "bg",
        { "StatusLine", "Normal" },
        "bg",
        black
    )
    local statusline_fg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "c",
        "fg",
        { "StatusLine", "Normal" },
        "fg",
        black
    )
    local normal_bg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "a",
        "bg",
        { "PmenuSel", "PmenuThumb", "TabLineSel" },
        "fg",
        get_terminal_color_with_fallback(0, magenta)
    )
    local normal_fg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "a",
        "fg",
        {},
        "fg",
        text_bg -- or black
    )
    local normal_bg1 = normal_bg
    local normal_fg1 = normal_fg
    local normal_bg2 = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "b",
        "bg",
        {},
        "bg",
        shade_rgb(normal_bg1, 0.5)
    )
    local normal_fg2 = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "b",
        "fg",
        {},
        "fg",
        text_fg
    )
    local normal_bg3 = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "c",
        "bg",
        {},
        "bg",
        shade_rgb(normal_bg1, 0.7)
    )
    local normal_fg3 = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "c",
        "fg",
        {},
        "fg",
        text_fg
    )
    local normal_bg4 = statusline_bg
    local normal_fg4 = text_fg
    local insert_bg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "insert",
        "a",
        "bg",
        { "String", "MoreMsg" },
        "fg",
        get_terminal_color_with_fallback(2, green)
    )
    local insert_fg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "insert",
        "a",
        "fg",
        {},
        "fg",
        text_fg
    )
    local visual_bg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "visual",
        "a",
        "bg",
        { "Special", "Boolean", "Constant" },
        "fg",
        get_terminal_color_with_fallback(3, yellow)
    )
    local visual_fg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "visual",
        "a",
        "fg",
        {},
        "fg",
        text_fg
    )
    local replace_bg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "replace",
        "a",
        "bg",
        { "Number", "Type" },
        "fg",
        get_terminal_color_with_fallback(4, blue)
    )
    local replace_fg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "replace",
        "a",
        "fg",
        {},
        text_fg
    )
    local command_bg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "command",
        "a",
        "bg",
        { "Identifier" },
        "fg",
        get_terminal_color_with_fallback(1, red)
    )
    local command_fg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "command",
        "a",
        "fg",
        {},
        "fg",
        text_fg
    )

    return {
        text_bg = text_bg,
        text_fg = text_fg,
        statusline_bg = statusline_bg,
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
    }
end

require("heirline").setup({
    statusline = StatusLine,
    opts = {
        colors = setup_colors(vim.g.colors_name),
    },
})

vim.api.nvim_create_augroup("heirline_augroup", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
    group = "heirline_augroup",
    callback = function(event)
        local colorname = event.match
        utils.on_colorscheme(setup_colors(colorname))
    end,
})
vim.api.nvim_create_autocmd("VimEnter", {
    group = "heirline_augroup",
    callback = function()
        local colorname = vim.g.colors_name
        utils.on_colorscheme(setup_colors(colorname))
    end,
})
