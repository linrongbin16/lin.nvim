local function GitStatus()
    local branch = vim.b.gitsigns_head
    if branch == nil or branch == '' then
        return ''
    end
    local changes = vim.b.gitsigns_status
    if changes == nil or changes == '' then
        return string.format(' %s', branch)
    else
        return string.format(' %s %s', branch, changes)
    end
end

local function Rtrim(s)
    local n = #s
    while n > 0 and s:find("^%s", n) do n = n - 1 end
    return s:sub(1, n)
end

local function LspProgress()
    if #vim.lsp.buf_get_clients() > 0 then
        return Rtrim(require('lsp-status').status())
    end
    return ''
end

local function CursorLocation()
    return ' %3l:%-2v'
end

local function CursorHex()
    return '0x%02B'
end

local function TagsStatus()
    if not vim.fn.exists('*gutentags#statusline') then
        return ''
    end
    local tags_status = vim.fn['gutentags#statusline']()
    if tags_status == nil or tags_status == '' then
        return ''
    end
    return tags_status
end

local constants = require('conf/constants')

local config = {
    options = {
        icons_enabled = true,
        -- theme = 'auto',
        -- component_separators = {'', ''},
        -- section_separators = {'', ''},
        disabled_filetypes = {},
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'filename' },
        lualine_c = {
            GitStatus, {
                'diagnostics',
                symbols = {
                    error = constants.lsp.diagnostics.signs['error'] .. ' ',
                    warn = constants.lsp.diagnostics.signs['warning'] .. ' ',
                    info = constants.lsp.diagnostics.signs['info'] .. ' ',
                    hint = constants.lsp.diagnostics.signs['hint'] .. ' ',
                },
            },
            LspProgress,
            TagsStatus
        },
        lualine_x = {
            CursorHex,
            'filetype', {
                'fileformat',
                symbols = {
                    unix = ' LF', -- e712
                    dos = ' CRLF',  -- e70f
                    mac = ' CR',  -- e711
                },
            }, 
            'encoding'
        },
        lualine_y = { 'progress' },
        lualine_z = { CursorLocation },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

require('lualine').setup(config)
