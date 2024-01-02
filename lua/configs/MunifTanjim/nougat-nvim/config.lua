local constants = require("builtin.utils.constants")

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
        filetype_icon = require("nougat.nut.buf.filetype_icon").create,
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

local function git_branch()
    if vim.g.loaded_gitbranch == nil or vim.g.loaded_gitbranch <= 0 then
        return ""
    end
    local name = vim.fn["gitbranch#name"]()
    return name or ""
end

local function git_diff()
    if vim.g.loaded_gitgutter == nil or vim.g.loaded_gitgutter <= 0 then
        return ""
    end
    local changes = vim.fn["GitGutterGetHunkSummary"]()
    if changes == nil or #changes ~= 3 then
        return ""
    end
    local symbols = { "+", "~", "-" }
    local builder = {}
    for i, c in ipairs(changes) do
        if type(c) == "number" and c > 0 then
            table.insert(builder, string.format("%s%d", symbols[i], c))
        end
    end
    return table.concat(builder, " ")
end

-- git branch and status
stl:add_item(Item({
    hl = { bg = color.magenta, fg = color.bg },
    sep_right = sep.right_upper_triangle_solid(true),
    prefix = "  ",
    suffix = " ",
    type = "lua_expr",
    content = function(ctx)
        local branch = git_branch()
        if string.len(branch) == 0 then
            return ""
        end
        local changes = git_diff()
        if string.len(changes) == 0 then
            return branch
        else
            return branch .. " " .. changes
        end
    end,
}))

-- -- git changes
stl:add_item(nut.git.status.create({
    hl = { fg = color.bg },
    content = {
        nut.git.status.count("added", {
            hl = { bg = color.green },
            prefix = "+",
            sep_right = sep.right_upper_triangle_solid(true),
        }),
        nut.git.status.count("changed", {
            hl = { bg = color.yellow },
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
    prefix = " ",
    suffix = " ",
    content = {
        nut.buf.filetype_icon({ suffix = " " }),
        nut.buf.filetype({}),
    },
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
