lua << END
local function LinGitStatus()
    local branch=vim.b.gitsigns_head
    if branch == nil or branch == '' then
        return ''
    end
    local changes=vim.b.gitsigns_status
    if changes == nil or changes == '' then
        return string.format(' %s', branch)
    else
        return string.format(' %s %s', branch, changes)
    end
end
local function LinLspStatus()
    if #vim.lsp.buf_get_clients() > 0 then
        return require('lsp-status').status()
    end
    return ''
end
local function LinCursorPosition()
    return ' %3l:%-2v'
end
local function LinCursorHex()
    return '0x%B'
end
local function LinTagsStatus()
    if not vim.fn.exists('*gutentags#statusline') then
        return ''
    end
    local tags_status = vim.fn['gutentags#statusline']()
    if tags_status == nil or tags_status == '' then
        return ''
    end
    return tags_status
end

local config = {
    options = {
        icons_enabled = true,
        -- theme = 'auto',
        -- component_separators = {'', ''},
        -- section_separators = {'', ''},
        disabled_filetypes = {},
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'filename'},
        lualine_c = {LinGitStatus, LinLspStatus, LinTagsStatus},
        lualine_x = {LinCursorHex, 'filetype', 'fileformat', 'encoding'},
        lualine_y = {'progress'},
        lualine_z = {LinCursorPosition},
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
}

require('lualine').setup(config)
END
