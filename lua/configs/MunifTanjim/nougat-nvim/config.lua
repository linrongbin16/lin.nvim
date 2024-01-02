local constants = require("builtin.utils.constants")
local message = require("builtin.utils.message")

local nougat = require("nougat")
local core = require("nougat.core")
local Bar = require("nougat.bar")
local Item = require("nougat.item")
local sep = require("nougat.separator")

local nut = {
    buf = {
        diagnostic_count = require("nougat.nut.buf.diagnostic_count").create,
        filename = require("nougat.nut.buf.filename").create,
        filestatus = require("nougat.nut.buf.filestatus").create,
        filetype = require("nougat.nut.buf.filetype").create,
        fileformat = require("nougat.nut.buf.fileformat").create,
        fileencoding = require("nougat.nut.buf.fileencoding").create,
    },
    git = {
        branch = require("nougat.nut.git.branch").create,
        status = require("nougat.nut.git.status"),
    },
    tab = {
        tablist = {
            tabs = require("nougat.nut.tab.tablist").create,
            close = require("nougat.nut.tab.tablist.close").create,
            icon = require("nougat.nut.tab.tablist.icon").create,
            label = require("nougat.nut.tab.tablist.label").create,
            modified = require("nougat.nut.tab.tablist.modified").create,
        },
    },
    mode = require("nougat.nut.mode").create,
    spacer = require("nougat.nut.spacer").create,
    truncation_point = require("nougat.nut.truncation_point").create,
}

---@type nougat.color
local color = require("nougat.color").get()

local mode = nut.mode({
    prefix = " ",
    suffix = " ",
    sep_right = sep.right_lower_triangle_solid(true),
})

local stl = Bar("statusline")

-- mode
stl:add_item(mode)

-- git branch
stl:add_item(nut.git.branch({
    hl = { bg = color.magenta, fg = color.bg },
    prefix = "  ",
    suffix = " ",
    sep_right = sep.right_upper_triangle_solid(true),
}))

-- git changes
stl:add_item(nut.git.status.create({
    hl = { fg = color.bg },
    content = {
        nut.git.status.count("added", {
            hl = { bg = color.green },
            prefix = "+",
            sep_right = sep.right_upper_triangle_solid(true),
        }),
        nut.git.status.count("changed", {
            hl = { bg = color.orange },
            prefix = "~",
            sep_right = sep.right_upper_triangle_solid(true),
        }),
        nut.git.status.count("removed", {
            hl = { bg = color.red },
            prefix = "-",
            sep_right = sep.right_upper_triangle_solid(true),
        }),
    },
}))

-- file name
stl:add_item(nut.buf.filename({
    hl = { bg = color.bg3 },
    prefix = " ",
    suffix = " ",
}))

-- file status
stl:add_item(nut.buf.filestatus({
    hl = { bg = color.bg3 },
    suffix = " ",
    sep_right = sep.right_lower_triangle_solid(true),
    config = {
        modified = "󰏫",
        nomodifiable = "󰏯",
        readonly = "",
        sep = " ",
    },
}))

-- spaces
stl:add_item(nut.spacer())
stl:add_item(nut.truncation_point())

-- diagnostics
stl:add_item(nut.buf.diagnostic_count({
    sep_left = sep.left_lower_triangle_solid(true),
    prefix = " ",
    suffix = " ",
    config = {
        error = { prefix = constants.diagnostic.sign.error .. " " },
        warn = { prefix = constants.diagnostic.sign.warning .. " " },
        info = { prefix = constants.diagnostic.sign.info .. " " },
        hint = { prefix = constants.diagnostic.sign.hint .. " " },
    },
}))

-- file type
stl:add_item(Item({
    hl = { bg = color.bg1 },
    sep_left = sep.left_lower_triangle_solid(true),
    suffix = " ",
    type = "lua_expr",
    content = function(ctx)
        message.info("|nougat.filetype| ctx:%s", vim.inspect(ctx))
        local hl_name = "LinNvimNougatFileTypeHighlight"
        local ft =
            vim.api.nvim_get_option_value("filetype", { buf = ctx.bufnr })
        local ok, devicons = pcall(require, "nvim-web-devicons")
        if not ok then
            return ft or ""
        end
        local icon_text, icon_color = devicons.get_icon_color_by_filetype(ft)
        message.info(
            "|nougat.filetype| ctx:%s, icon_text:%s, icon_color:%s",
            vim.inspect(ctx),
            vim.inspect(icon_text),
            vim.inspect(icon_color)
        )
        if type(icon_text) == "string" and type(icon_color) == "string" then
            vim.api.nvim_set_hl(0, hl_name, { fg = icon_color })
            return "%#" .. hl_name .. "#" .. icon_text .. "%*" .. ft
        else
            return ft or ""
        end
    end,
}))

-- file format
stl:add_item(nut.buf.fileformat({
    hl = { bg = color.bg1 },
    sep_left = sep.left_lower_triangle_solid(true),
    suffix = " ",
    config = {
        text = {
            unix = " LF", -- e712
            dos = " CRLF", -- e70f
            mac = " CR", -- e711
        },
    },
}))

stl:add_item(nut.buf.fileencoding({
    hl = { bg = color.bg1 },
    sep_left = sep.left_lower_triangle_solid(true),
    suffix = " ",
}))

-- locations
stl:add_item(Item({
    hl = { bg = color.bg2, fg = color.blue },
    sep_left = sep.left_lower_triangle_solid(true),
    prefix = "  ",
    content = core.group({
        core.code("l"),
        ":",
        core.code("c"),
    }),
    suffix = " ",
}))

-- locations
stl:add_item(Item({
    hl = { bg = color.blue, fg = color.bg },
    sep_left = sep.left_lower_triangle_solid(true),
    prefix = " ",
    content = core.code("P"),
    suffix = " ",
}))

nougat.set_statusline(stl)
