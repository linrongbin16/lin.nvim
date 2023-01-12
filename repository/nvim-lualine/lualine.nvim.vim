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

local function LinRtrim(s)
  local n = #s
  while n > 0 and s:find("^%s", n) do n = n - 1 end
  return s:sub(1, n)
end

local LinSpinnerFrames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }
local LinSpinnerFramesLength = #LinSpinnerFrames
local LinServerAliases = {pyls_ms = 'MPLS'}
local function LinLspProgress()
  if #vim.lsp.buf_get_clients() <= 0 then
    return ''
  end

  local buf_messages = require('lsp-status').messages()

  -- lsp-status API references:
  -- status(): https://github.com/nvim-lua/lsp-status.nvim/blob/master/lua/lsp-status/statusline.lua#L38
  -- messages(): https://github.com/nvim-lua/lsp-status.nvim/blob/master/lua/lsp-status/messaging.lua#L60
  --
  -- LSP progress message
  local progress_msgs = {}
  local debug_msgs = {}
  for i, msg in ipairs(buf_messages) do
    table.insert(debug_msgs, string.format(
        '{%d, name:%s, title:%s, message:%s, content:%s, uri:%s, status:%s}', 
        i, tostring(msg.name), tostring(msg.title), tostring(msg.message), tostring(msg.content), tostring(msg.uri), tostring(msg.status)))
    local name = LinServerAliases[msg.name] or msg.name
    local client_name = '[' .. name .. ']'
    local contents = ''
    if msg.progress then
      contents = msg.title
      if msg.message then contents = contents .. ' ' .. msg.message end

      -- this percentage format string escapes a percent sign once to show a percentage and one more
      -- time to prevent errors in vim statusline's because of it's treatment of % chars
      if msg.percentage then contents = contents .. string.format(" (%.0f%%%%)", msg.percentage) end

      if msg.spinner then
        contents = LinSpinnerFrames[(msg.spinner % LinSpinnerFramesLength) + 1] .. ' ' .. contents
      end
    else
      contents = msg.content
    end

    table.insert(progress_msgs, client_name .. ' ' .. contents)
  end
  local progresses = table.concat(progress_msgs, " ")
  if progresses == nil or progresses == '' then
    return 'ﬦ'
  else
    return 'ﬦ ' .. progresses
  end
end

local function LinLspStatus()
    if #vim.lsp.buf_get_clients() > 0 then
        return LinRtrim(require('lsp-status').status())
    end
    return ''
end

local LspDiagnosticIndicators = {
    errors = '✘',
    warnings = '',
    hints = '⚑',
    info = '',
}
local function LinLspDiagnostics()
    if #vim.lsp.buf_get_clients() > 0 then
        local diags = require('lsp-status').diagnostics()
        if diags ~= nil then
            local messages = {}
            -- local msg = {}
            for k, c in pairs(diags) do
                -- table.insert(msg, string.format('%s:%d', k, c))
                if c > 0 then
                    table.insert(messages, string.format('%s %d', LspDiagnosticIndicators[k], c))
                end
            end
            -- print(table.concat(msg, ","))
            if #messages > 0 then
                return table.concat(messages, " ")
            else
                return ''
            end
        end
    end
    return ''
end

local function LinLspCurrentFunction()
    local current_function = vim.b.lsp_current_function
    if current_function and current_function ~= '' then
        return string.format(' %s', current_function)
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
        lualine_c = {LinGitStatus, LinLspDiagnostics, LinLspCurrentFunction, LinLspProgress, LinTagsStatus},
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
