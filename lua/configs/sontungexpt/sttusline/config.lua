local colors_hsl = require("commons.colors.hsl")
local colors_hl = require("commons.colors.hl")
local uv = require("commons.uv")

local sttusline_colors = require("sttusline.utils.color")

local function ModifyColorBrightness(rgb, percent)
    local h, s, l = colors_hsl.rgb_string_to_hsl(rgb)
    local tmp = colors_hsl.new(h, s, l, rgb)
    return vim.o.background == "light" and tmp:tint(percent):to_rgb()
        or tmp:shade(percent):to_rgb()
end

local NormalBgColor = colors_hl.get_color_with_fallback(
    { "PmenuSel", "PmenuThumb", "TabLineSel" },
    "bg",
    sttusline_colors.blue
)
local InsertBgColor = colors_hl.get_color_with_fallback(
    { "String", "MoreMsg" },
    "fg",
    sttusline_colors.green
)
local ReplaceBgColor = colors_hl.get_color_with_fallback(
    { "Number", "Type" },
    "fg",
    sttusline_colors.red
)
local VisualBgColor = colors_hl.get_color_with_fallback(
    { "Special", "Boolean", "Constant" },
    "fg",
    sttusline_colors.purple
)
local CommandBgColor = colors_hl.get_color_with_fallback(
    { "Identifier" },
    "fg",
    sttusline_colors.yellow
)
local BlackColor = colors_hl.get_color_with_fallback(
    { "Normal" },
    "bg",
    sttusline_colors.black
)
local WhiteColor = colors_hl.get_color_with_fallback(
    { "Normal" },
    "fg",
    sttusline_colors.white
)
local StatusLineColor =
    colors_hl.get_color_with_fallback({ "StatusLine", "Normal" }, "bg")

local HighlightA = {
    bg = NormalBgColor,
    fg = WhiteColor,
    gui = "bold",
}
local HighlightB = {
    bg = ModifyColorBrightness(NormalBgColor, 0.5),
    fg = WhiteColor,
    gui = "bold",
}
local HighlightC = {
    bg = ModifyColorBrightness(NormalBgColor, 0.5),
    fg = WhiteColor,
    gui = "bold",
}
local HighlightD = {
    bg = StatusLineColor,
    fg = WhiteColor,
    gui = "bold",
}

local FullModeName = {
    NORMAL = "NORMAL",
    O_PENDING = "O-PENDING",
    VISUAL = "VISUAL",
    V_LINE = "V-LINE",
    V_BLOCK = "V-BLOCK",
    SELECT = "SELECT",
    S_LINE = "S-LINE",
    S_BLOCK = "S-BLOCK",
    INSERT = "INSERT",
    REPLACE = "REPLACE",
    V_REPLACE = "V-REPLACE",
    COMMAND = "COMMAND",
    CONFIRM = "CONFIRM",
    EX = "EX",
    MORE = "MORE",
    SHELL = "SHELL",
    TERMINAL = "TERMINAL",
}
local AbbrModeName = {
    NORMAL = "N",
    O_PENDING = "O",
    VISUAL = "V",
    V_LINE = "V",
    V_BLOCK = "V",
    SELECT = "S",
    S_LINE = "S",
    S_BLOCK = "S",
    INSERT = "I",
    REPLACE = "R",
    V_REPLACE = "V",
    COMMAND = "C",
    CONFIRM = "C",
    EX = "E",
    MORE = "M",
    SHELL = "S",
    TERMINAL = "T",
}

local OS_UNAME = uv.os_uname()

local function OsNameIcon()
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

local Mode = {
    name = "mode",
    event = { "ModeChanged", "VimResized" },
    user_event = "VeryLazy",
    configs = {
        modes = {
            ["n"] = { "NORMAL", "STTUSLINE_NORMAL_MODE" },
            ["no"] = { "O_PENDING", "STTUSLINE_O_PENDING_MODE" },
            ["nov"] = { "O_PENDING", "STTUSLINE_O_PENDING_MODE" },
            ["noV"] = { "O_PENDING", "STTUSLINE_O_PENDING_MODE" },
            ["noCTRL-V"] = { "O_PENDING", "STTUSLINE_O_PENDING_MODE" },
            ["niI"] = { "NORMAL", "STTUSLINE_NORMAL_MODE" },
            ["niR"] = { "NORMAL", "STTUSLINE_NORMAL_MODE" },
            ["niV"] = { "NORMAL", "STTUSLINE_NORMAL_MODE" },

            ["nt"] = { "NORMAL", "STTUSLINE_NORMAL_MODE" },
            ["ntT"] = { "NORMAL", "STTUSLINE_NORMAL_MODE" },

            ["v"] = { "VISUAL", "STTUSLINE_VISUAL_MODE" },
            ["vs"] = { "VISUAL", "STTUSLINE_VISUAL_MODE" },
            ["V"] = { "V_LINE", "STTUSLINE_VISUAL_MODE" },
            ["Vs"] = { "V_LINE", "STTUSLINE_VISUAL_MODE" },
            [""] = { "V_BLOCK", "STTUSLINE_VISUAL_MODE" },

            ["s"] = { "SELECT", "STTUSLINE_SELECT_MODE" },
            ["S"] = { "S_LINE", "STTUSLINE_SELECT_MODE" },
            [""] = { "S_BLOCK", "STTUSLINE_SELECT_MODE" },

            ["i"] = { "INSERT", "STTUSLINE_INSERT_MODE" },
            ["ic"] = { "INSERT", "STTUSLINE_INSERT_MODE" },
            ["ix"] = { "INSERT", "STTUSLINE_INSERT_MODE" },

            ["t"] = { "TERMINAL", "STTUSLINE_TERMINAL_MODE" },
            ["!"] = { "SHELL", "STTUSLINE_TERMINAL_MODE" },

            ["R"] = { "REPLACE", "STTUSLINE_REPLACE_MODE" },
            ["Rc"] = { "REPLACE", "STTUSLINE_REPLACE_MODE" },
            ["Rx"] = { "REPLACE", "STTUSLINE_REPLACE_MODE" },
            ["Rv"] = { "REPLACE", "STTUSLINE_REPLACE_MODE" },
            ["Rvc"] = { "REPLACE", "STTUSLINE_REPLACE_MODE" },
            ["Rvx"] = { "REPLACE", "STTUSLINE_REPLACE_MODE" },

            ["c"] = { "COMMAND", "STTUSLINE_COMMAND_MODE" },
            ["cv"] = { "EX", "STTUSLINE_COMMAND_MODE" },
            ["ce"] = { "EX", "STTUSLINE_COMMAND_MODE" },

            ["r"] = { "REPLACE", "STTUSLINE_REPLACE_MODE" },
            ["rm"] = { "MORE", "STTUSLINE_CONFIRM_MODE" },
            ["r?"] = { "CONFIRM", "STTUSLINE_CONFIRM_MODE" },
            ["x"] = { "CONFIRM", "STTUSLINE_CONFIRM_MODE" },
        },
        mode_colors = {
            ["STTUSLINE_NORMAL_MODE"] = { fg = WhiteColor, bg = NormalBgColor },
            ["STTUSLINE_INSERT_MODE"] = { fg = WhiteColor, bg = InsertBgColor },
            ["STTUSLINE_VISUAL_MODE"] = { fg = WhiteColor, bg = VisualBgColor },
            ["STTUSLINE_TERMINAL_MODE"] = {
                fg = WhiteColor,
                bg = CommandBgColor,
            },
            ["STTUSLINE_REPLACE_MODE"] = {
                fg = WhiteColor,
                bg = ReplaceBgColor,
            },
            ["STTUSLINE_SELECT_MODE"] = { fg = WhiteColor, bg = VisualBgColor },
            ["STTUSLINE_COMMAND_MODE"] = {
                fg = WhiteColor,
                bg = CommandBgColor,
            },
            ["STTUSLINE_CONFIRM_MODE"] = {
                fg = WhiteColor,
                bg = CommandBgColor,
            },
        },
    },
    update = function(configs)
        local mode_code = vim.api.nvim_get_mode().mode
        local mode_name = configs.modes[mode_code][1]
        local mode_color = configs.modes[mode_code][2]
        local os_icon = OsNameIcon()
        if mode_name then
            if vim.o.columns > 70 then
                return {
                    {
                        os_icon .. " " .. FullModeName[mode_name],
                        configs.mode_colors[mode_color],
                    },
                }
            else
                return {
                    {
                        os_icon .. " " .. AbbrModeName[mode_name],
                        configs.mode_colors[mode_color],
                    },
                }
            end
        end
        return " " .. os_icon .. " " .. string.upper(mode_code) .. " "
    end,
}

local Components = {
    Mode,
    "filename",
    "git-branch",
    "git-diff",
    "%=",
    "diagnostics",
    "lsps-formatters",
    "copilot",
    "copilot-loading",
    "indent",
    "encoding",
    "pos-cursor",
    "pos-cursor-progress",
}

require("sttusline").setup({
    on_attach = function(create_update_group) end,
    statusline_color = "StatusLine",
    components = Components,
})
