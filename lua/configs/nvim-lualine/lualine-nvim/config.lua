local str = require("commons.str")
local tbl = require("commons.tbl")
local spawn = require("commons.spawn")

local constants = require("builtin.constants")

local git_branch_name_cache = nil
local git_branch_status_cache = nil

local function GitBranchCondition()
  return str.not_empty(git_branch_name_cache)
end

local function GitBranch()
  -- if str.empty(git_branch_name_cache) then
  --   return ""
  -- end

  local branch = "  " .. git_branch_name_cache .. " "

  if type(git_branch_status_cache) == "table" then
    if git_branch_status_cache["changed"] ~= nil then
      branch = branch .. "* "
    end
    if type(git_branch_status_cache["ahead"]) == "number" then
      branch = branch .. string.format("↑[%d] ", git_branch_status_cache["ahead"])
    end
    if type(git_branch_status_cache["behind"]) == "number" then
      branch = branch .. string.format("↓[%d] ", git_branch_status_cache["behind"])
    end
  end

  return branch
end

local function GitDiffCondition()
  return vim.fn.exists("*GitGutterGetHunkSummary") > 0
end

local function GitDiffSource()
  local changes = vim.fn.GitGutterGetHunkSummary() or {}
  return {
    added = changes[1] or 0,
    modified = changes[2] or 0,
    removed = changes[3] or 0,
  }
end

local function LspStatus()
  local status = require("lsp-progress").progress()
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
    section_separators = slash_section_separators,
    refresh = {
      statusline = 3000,
      tabline = 10000,
      winbar = 10000,
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
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
    },
    lualine_c = {
      { GitBranch, cond = GitBranchCondition },
      {
        "diff",
        cond = GitDiffCondition,
        source = GitDiffSource,
        padding = { left = 1, right = 1 },
      },
      LspStatus,
    },
    lualine_x = {
      { "searchcount", maxcount = 100, timeout = 300 },
      {
        "diagnostics",
        symbols = {
          error = constants.diagnostic.signs.error .. " ",
          warn = constants.diagnostic.signs.warning .. " ",
          info = constants.diagnostic.signs.info .. " ",
          hint = constants.diagnostic.signs.hint .. " ",
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
      { CursorHex, padding = { right = 0 } },
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
  pattern = { "LspProgressStatusUpdated", "GitGutter" },
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
      local branch_status = parse_git_status(status_info)

      if
        type(branch_status) == "table"
        and type(branch_status.branch) == "string"
        and string.len(branch_status.branch) > 0
      then
        git_branch_name_cache = branch_status.branch
      end

      if tbl.tbl_not_empty(branch_status) then
        git_branch_status_cache = branch_status
      else
        git_branch_status_cache = nil
      end
    end
    vim.schedule(function()
      vim.api.nvim_exec_autocmds("User", {
        pattern = "HeirlineGitBranchUpdated",
        modeline = false,
      })
      vim.schedule(function()
        updating_git_branch = false
      end)
    end)
  end)
end

vim.api.nvim_create_autocmd(
  { "FocusGained", "FocusLost", "TermLeave", "TermClose", "DirChanged", "BufEnter", "VimEnter" },
  {
    group = lualine_augroup,
    callback = update_git_branch,
  }
)
