local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local uv = require("commons.uv")
local strings = require("commons.strings")
local tables = require("commons.tables")
local colors_hl = require("commons.colors.hl")

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

local ModeColors = {
    n = "red",
    i = "green",
    v = "cyan",
    V = "cyan",
    ["\22"] = "cyan",
    c = "orange",
    s = "purple",
    S = "purple",
    ["\19"] = "purple",
    R = "orange",
    r = "orange",
    ["!"] = "red",
    t = "red",
}

local OS_UNAME = uv.os_uname()

local function GetOsName()
    local uname = OS_UNAME.sysname
    if uname == "Darwin" then
        return ""
    elseif uname == "Linux" then
        if
            type(OS_UNAME.release) == "string" and OS_UNAME.release:find("arch")
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

local function GetModeName(mode)
    return ModeNames[mode] or "???"
end

local Mode = {
    init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
    end,
    provider = function(self)
        return " " .. GetOsName() .. " " .. GetModeName(self.mode) .. " "
    end,
    hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { fg = ModeColors[mode], bold = true }
    end,
    update = {
        { "ModeChanged", "VimResized" },
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
        end),
    },
}

local StatusLine = {}

require("heirline").setup({
    statusline = StatusLine,
    opts = {
        colors = colors,
    },
})

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
        and strings.not_empty(
            tables.tbl_get(lualine_theme, mode_name, section, attribute)
        )
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

local function setup_colors(colorname)
    local diagnostic_error = colors_hl.get_color_with_fallback(
        { "DiagnosticSignError", "ErrorMsg" },
        "fg",
        "#FF0000"
    )
    local diagnostic_warn = colors_hl.get_color_with_fallback(
        { "DiagnosticSignWarn", "WarningMsg" },
        "fg",
        "#FFFF00"
    )
    local diagnostic_info = colors_hl.get_color_with_fallback(
        { "DiagnosticSignInfo", "None" },
        "fg",
        "#00FFFF"
    )
    local diagnostic_hint = colors_hl.get_color_with_fallback(
        { "DiagnosticSignHint", "Comment" },
        "fg",
        "#808080"
    )
    local git_add = colors_hl.get_color_with_fallback(
        { "GitSignsAdd", "GitGutterAdd", "diffAdded", "DiffAdd" },
        "fg",
        "#008000"
    )
    local git_change = colors_hl.get_color_with_fallback(
        { "GitSignsChange", "GitGutterChange", "diffChanged", "DiffChange" },
        "fg",
        "#FFFF00"
    )
    local git_delete = colors_hl.get_color_with_fallback(
        { "GitSignsDelete", "GitGutterDelete", "diffRemoved", "DiffDelete" },
        "fg",
        "#FF0000"
    )

    local lualine_ok, lualine_theme = pcall(require("module"))
    local text_bg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "a",
        "bg",
        { "Normal" },
        "#000000"
    )
    local text_fg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "a",
        "fg",
        { "Normal" },
        "#ffffff"
    )
    local normal_bg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "a",
        "bg",
        {},
        vim.g.terminal_color_0 or "#FF00FF"
    )
    local normal_fg = get_color_with_lualine(
        lualine_ok,
        lualine_theme,
        "normal",
        "a",
        "fg",
        {},
        "#000000"
    )
    local dark_red = get_color_with_lualine(lualine_ok, lualine_theme, "normal")
    local green
    local blue
    local grey
    local orange
    local yellow
    local purple
    local cyan

    local colors = {
        bright_bg = utils.get_highlight("Folded").bg,
        bright_fg = utils.get_highlight("Folded").fg,
        red = utils.get_highlight("DiagnosticError").fg,
        dark_red = utils.get_highlight("DiffDelete").bg,
        green = utils.get_highlight("String").fg,
        blue = utils.get_highlight("Function").fg,
        gray = utils.get_highlight("NonText").fg,
        orange = utils.get_highlight("Constant").fg,
        purple = utils.get_highlight("Statement").fg,
        cyan = utils.get_highlight("Special").fg,
        diag_warn = utils.get_highlight("DiagnosticWarn").fg,
        diag_error = utils.get_highlight("DiagnosticError").fg,
        diag_hint = utils.get_highlight("DiagnosticHint").fg,
        diag_info = utils.get_highlight("DiagnosticInfo").fg,
        git_add = colors_hl.get_color_with_fallback(
            { "GitSignsAdd", "GitGutterAdd", "diffAdded", "DiffAdd" },
            "fg",
            "#008000"
        ),
        git_change = colors_hl.get_color_with_fallback(
            { "GitSignsChange", "GitGutterChange", "diffChanged", "DiffChange" },
            "fg",
            "#FFFF00"
        ),
        git_delete = colors_hl.get_color_with_fallback(
            { "GitSignsDelete", "GitGutterDelete", "diffRemoved", "DiffDelete" },
            "fg",
            "#FF0000"
        ),
    }
end

vim.api.nvim_create_augroup("heirline_augroup", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
    group = "heirline_augroup",
    callback = function(event)
        local colorname = event.match
    end,
})
vim.api.nvim_create_autocmd("VimEnter", {
    group = "heirline_augroup",
    callback = function()
        local colorname = vim.g.colors_name
    end,
})
