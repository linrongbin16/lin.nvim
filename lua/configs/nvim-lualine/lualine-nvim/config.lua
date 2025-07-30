local str = require("commons.str")
local tbl = require("commons.tbl")
local spawn = require("commons.spawn")

local constants = require("builtin.constants")

local git_branch_cache = nil
local git_status_cache = nil

local function GitBranchCondition()
  return str.not_empty(git_branch_cache)
end

local function GitBranch()
  local branch = " " .. git_branch_cache
  if git_status_cache and git_status_cache["changed"] then
    branch = branch .. "*"
  end
  return branch
end

local function GitStatusCondition()
  return tbl.tbl_not_empty(git_status_cache)
end

local function GitStatus()
  local status = ""
  if git_status_cache and type(git_status_cache["ahead"]) == "number" then
    status = status .. string.format(" ↑[%d]", git_status_cache["ahead"])
  end
  if git_status_cache and type(git_status_cache["behind"]) == "number" then
    status = status .. string.format(" ↓[%d]", git_status_cache["behind"])
  end

  return str.trim(status)
end

local function GitStatusColor()
  for i = 1, 3 do
    local name = string.format("terminal_color_%d", i)
    local color = vim.g[name]
    if str.not_empty(color) then
      return { fg = color }
    end
  end
  local yellow = "#FFFF00"
  return { fg = yellow }
end

local function GitDiffCondition()
  return vim.fn.exists("*GitGutterGetHunkSummary") > 0
end

local function GitDiff()
  local changes = vim.fn.GitGutterGetHunkSummary() or {}
  return {
    added = changes[1] or 0,
    modified = changes[2] or 0,
    removed = changes[3] or 0,
  }
end

local function LspStatus()
  local max_size = math.max(10, (vim.o.columns + 2) / 2)
  local status = require("lsp-progress").progress({ max_size = max_size })
  return type(status) == "string" and string.len(status) > 0 and status or ""
end

local function Location()
  return " %3l:%-2v"
end

local function Progress()
  local bar = " "
  local line_fraction = math.floor(vim.fn.line(".") / vim.fn.line("$") * 100)
  if line_fraction >= 100 then
    return bar .. "Bot "
  elseif line_fraction <= 0 then
    return bar .. "Top "
  else
    return string.format("%s%2d%%%% ", bar, line_fraction)
  end
end

local function CursorHex()
  return " 0x%04B"
end

local empty_component_separators = { left = "", right = "" }
local empty_section_separators = { left = "", right = "" }

-- style-1: A > B > C ---- X < Y < Z
local angle_component_separators = { left = "", right = "" }
local angle_section_separators = { left = "", right = "" }

-- style-2: A \ B \ C ---- X / Y / Z
local slash_component_separators = { left = "", right = "" }
local slash_section_separators = { left = "", right = "" }

local config = {
  options = {
    icons_enabled = true,
    component_separators = empty_component_separators,
    section_separators = empty_section_separators,
    refresh = {
      statusline = 5000,
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      { GitBranch, cond = GitBranchCondition },
      {
        GitStatus,
        cond = GitStatusCondition,
        color = GitStatusColor,
        padding = { left = 0, right = 1 },
      },
    },
    lualine_c = {
      {
        "filename",
        file_status = true,
        symbols = {
          modified = "[]", -- Text to show when the file is modified.
          readonly = "[]", -- Text to show when the file is non-modifiable or readonly.
          unnamed = "[No Name]", -- Text to show for unnamed buffers.
          newfile = "[New]", -- Text to show for newly created file before first write
        },
      },
      {
        "diff",
        cond = GitDiffCondition,
        source = GitDiff,
        padding = 1,
      },
      LspStatus,
    },
    lualine_x = {
      { "searchcount", maxcount = 100, timeout = 300 },
      {
        "diagnostics",
        symbols = {
          error = constants.diagnostics.error .. " ",
          warn = constants.diagnostics.warning .. " ",
          info = constants.diagnostics.info .. " ",
          hint = constants.diagnostics.hint .. " ",
        },
      },
      "filetype",
    },
    lualine_y = {
      {
        "fileformat",
        symbols = {
          unix = " LF", -- e712
          dos = " CRLF", -- e70f
          mac = " CR", -- e711
        },
      },
      {
        "encoding",
        fmt = function(text)
          local FileEncodingIcons = {
            ["utf-8"] = "󰉿",
            ["utf-16"] = "󰊀",
            ["utf-32"] = "󰊁",
            ["utf-8mb4"] = "󰊂",
            ["utf-16le"] = "󰊃",
            ["utf-16be"] = "󰊄",
          }
          local icon = FileEncodingIcons[text]
          if str.empty(icon) then
            return text
          else
            return icon .. " " .. text
          end
        end,
      },
    },
    lualine_z = {
      { CursorHex, padding = 0 },
      { Location, padding = { left = 1, right = 0 } },
      { Progress, padding = { left = 1, right = 0 } },
    },
  },
}

require("lualine").setup(config)

-- listen to lsp-progress event and refresh
local lualine_augroup = vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = lualine_augroup,
  pattern = { "LspProgressStatusUpdated", "GitGutter", "LualineGitBranchUpdated" },
  callback = function()
    require("lualine").refresh({
      place = { "statusline" },
    })
  end,
})
vim.api.nvim_create_autocmd({ "ModeChanged", "BufReadPre", "BufNewFile", "WinEnter" }, {
  group = lualine_augroup,
  callback = function()
    require("lualine").refresh({
      place = { "statusline" },
    })
  end,
})

-- git branch info

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
  spawn.detached({ "git", "-c", "color.status=never", "status", "-b", "--porcelain=v2" }, {
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
      and tbl.tbl_get(completed, "exitcode") == 0
      and tbl.list_not_empty(status_info)
    then
      local branch_status = parse_git_status(status_info) --[[@as table]]

      -- branch name
      if tbl.tbl_not_empty(branch_status) and str.not_empty(branch_status.branch) then
        git_branch_cache = branch_status.branch --[[@as string]]
      end

      -- status info
      if tbl.tbl_not_empty(branch_status) then
        git_status_cache = branch_status
      else
        git_status_cache = nil
      end
    end
    vim.schedule(function()
      vim.api.nvim_exec_autocmds("User", {
        pattern = "LualineGitBranchUpdated",
        modeline = false,
      })
      vim.schedule(function()
        updating_git_branch = false
      end)
    end)
  end)
end

vim.api.nvim_create_autocmd({
  "FocusGained",
  "FocusLost",
  "TermLeave",
  "TermClose",
  "DirChanged",
  "BufWritePost",
  "FileWritePost",
  "BufEnter",
  "VimEnter",
}, {
  group = lualine_augroup,
  callback = update_git_branch,
})
