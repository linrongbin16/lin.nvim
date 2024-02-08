local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local uv = require("commons.uv")
local strings = require("commons.strings")
local tables = require("commons.tables")
local colors_hl = require("commons.colors.hl")
local colors_hsl = require("commons.colors.hsl")

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
    if uname == "Darwin" then
        return ""
    elseif uname == "Linux" then
        if
            type(OS_UNAME.release) == "string"
            and OS_UNAME.release:find("arch")
        then
            return ""
        end
        return ""
    elseif uname == "Windows" then
        return ""
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
        update = { "BufEnter" },
    },
    {
        provider = right_slant,
        hl = { fg = "normal_bg2", bg = "normal_bg3" },
    },
}

local function GetFileName()
    local filepath = vim.api.nvim_buf_get_name(0)
    if strings.empty(filepath) then
        return nil
    end
    local filename = vim.fn.fnamemodify(filepath, ":t")
    if strings.empty(filename) then
        return nil
    end
    return filename
end

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
            local filename = GetFileName()
            if strings.empty(filename) then
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
            local filename = GetFileName()
            if strings.empty(filename) then
                return ""
            end
            local filesize = vim.fn.getfsize(filename)
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

local Separator1 = {
    provider = " ",
    hl = { fg = "normal_fg4", bg = "normal_bg4" },
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

local StatusLine = {
    Mode,
    GitBranch,
    FileName,
    Separator1,
    GitDiff,
    LspStatus,
}

---@param lualine_ok boolean
---@param lualine_theme table
---@param mode_name "normal"|"insert"|"visual"|"replace"|"command"|"inactive"
---@param section "a"|"b"|"c"
---@param attribute "fg"|"bg"
---@param fallback_hls string|string[]
---@param fallback_color string?
local function get_color_with_lualine(
    lualine_ok,
    lualine_theme,
    mode_name,
    section,
    attribute,
    fallback_hls,
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
            attribute,
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
        black
    )
    local text_fg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "a",
        "fg",
        { "Normal" },
        white
    )
    local statusline_bg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "c",
        "bg",
        { "StatusLine", "Normal" },
        black
    )
    local statusline_fg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "c",
        "fg",
        { "StatusLine", "Normal" },
        black
    )
    local normal_bg_fallback = colors_hl.get_color_with_fallback(
        { "PmenuSel", "PmenuThumb", "TabLineSel" },
        "bg",
        get_terminal_color_with_fallback(0, magenta)
    )
    local normal_bg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "a",
        "bg",
        {},
        normal_bg_fallback
    )
    local normal_fg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "a",
        "fg",
        {},
        black
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
        shade_rgb(normal_bg_fallback, 0.5)
    )
    local normal_fg2 = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "b",
        "fg",
        {},
        text_fg
    )
    local normal_bg3 = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "c",
        "bg",
        {},
        shade_rgb(normal_bg_fallback, 0.7)
    )
    local normal_fg3 = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "c",
        "fg",
        {},
        text_fg
    )
    local normal_bg4 = statusline_bg
    local normal_fg4 = statusline_fg
    local insert_bg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "insert",
        "a",
        "bg",
        {},
        get_terminal_color_with_fallback(2, green)
    )
    local insert_fg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "insert",
        "a",
        "fg",
        {},
        black
    )
    local visual_bg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "visual",
        "a",
        "bg",
        {},
        get_terminal_color_with_fallback(3, yellow)
    )
    local visual_fg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "visual",
        "a",
        "fg",
        {},
        black
    )
    local replace_bg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "replace",
        "a",
        "bg",
        {},
        get_terminal_color_with_fallback(4, blue)
    )
    local replace_fg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "replace",
        "a",
        "fg",
        {},
        black
    )
    local command_bg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "command",
        "a",
        "bg",
        {},
        get_terminal_color_with_fallback(1, red)
    )
    local command_fg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "command",
        "a",
        "fg",
        {},
        black
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
