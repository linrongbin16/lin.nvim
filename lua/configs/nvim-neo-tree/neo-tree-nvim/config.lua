local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")

local function trash_bin()
  local function wrap(trash_exe)
    local function impl(state)
      local inputs = require("neo-tree.ui.inputs")
      local path = state.tree:get_node().path
      local msg = "Are you sure you want to move '"
        .. vim.fn.fnamemodify(vim.fn.fnameescape(path), ":~:.")
        .. "' to trash bin?"
      local state_name = state.name
      inputs.confirm(msg, function(confirmed)
        if not confirmed then
          return
        end
        local cmds = {}
        for i, t in ipairs(trash_exe) do
          table.insert(cmds, t)
        end
        table.insert(cmds, vim.fn.fnameescape(path))
        vim.system(cmds, { text = true }, function(trash_completed)
          vim.schedule(function()
            require("neo-tree.sources.manager").refresh(state_name)
          end)
        end)
      end)
    end
    return impl
  end

  local MAC_TRASH = "/opt/homebrew/opt/trash/bin/trash" -- Only for MacOS
  local GTRASH = "gtrash" -- Only for Linux (FreeDesktop)
  local TRASHY = vim.fn.fnamemodify("~", ":p") .. "/.cargo/bin/trash" -- Only for Windows (its executable is still 'trash')

  if constants.os.is_macos and vim.fn.executable(MAC_TRASH) > 0 then
    return wrap({ MAC_TRASH })
  elseif not constants.os.is_macos and vim.fn.executable(GTRASH) > 0 then
    return wrap({ GTRASH, "put" })
  elseif vim.fn.executable(TRASHY) > 0 then
    return wrap({ TRASHY, "put" })
  else
    return "delete" -- by default 'rm' command
  end
end

require("neo-tree").setup({
  popup_border_style = constants.window.border,
  default_component_configs = {
    icon = {
      folder_closed = "", -- nf-custom-folder \ue5ff
      folder_open = "", -- nf-custom-folder_open \ue5fe
      folder_empty = "", -- nf-cod-folder \uea83
      folder_empty_open = "", -- nf-cod-folder_opened \ueaf7
      default = "", -- : nf-fa-file_text_o \uf0f6, : nf-fa-file_o \uf016
    },
    git_status = {
      symbols = {
        added = "", -- : nf-fa-plus \uf067, : nf-cod-diff_added \ueadc
        modified = "", -- : nf-fa-circle \uf111, : nf-oct-diff_modified \uf459
        deleted = "", -- : nf-oct-diff_removed \uf458, : nf-fa-minus \uf068, : nf-fa-times \uf00d(conflict with diagnostic error)
        renamed = "", -- : nf-fa-arrow_right \uf061, : nf-oct-diff_renamed \uf45a
        untracked = "", -- nf-fa-star \uf005
        ignored = "", -- nf-fa-circle_thin \uf1db
        unstaged = "✗", -- unicode: &#x2717;
        staged = "✓", -- unicode: &#x2713;
        conflict = "", -- nf-dev-git_merge \ue727
      },
    },
    file_size = {
      enabled = false,
    },
    type = {
      enabled = false,
    },
    last_modified = {
      enabled = false,
    },
    created = {
      enabled = false,
    },
    symlink_target = {
      enabled = true,
    },
  },
  window = {
    width = layout.editor.width(
      constants.layout.sidebar.scale,
      constants.layout.sidebar.min,
      constants.layout.sidebar.max
    ),
    mappings = {
      -- window pick
      ["w"] = "none",

      -- open node
      ["l"] = "open",
      -- close node
      ["h"] = function(state)
        local node = state.tree:get_node()
        if node.type == "directory" and node:is_expanded() then
          require("neo-tree.sources.filesystem").toggle_directory(state, node)
        else
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end
      end,

      -- delete
      ["d"] = trash_bin(),
    },
  },
  filesystem = {
    bind_to_cwd = false, -- disable 2-way binding
    -- cwd_target = {
    --   sidebar = "tab", -- sidebar is when position = left or right
    --   current = "window", -- current is when position = current
    -- },
    filtered_items = {
      visible = true,
    },
    follow_current_file = {
      enabled = false,
      leave_dirs_open = true,
    },
    use_libuv_file_watcher = true,
    window = {
      mappings = {
        ["<C-f>"] = "fuzzy_finder",
        ["/"] = "none",
        ["[c"] = "prev_git_modified",
        ["]c"] = "next_git_modified",
      },
    },
  },
})

local neo_tree_augroup = vim.api.nvim_create_augroup("neo_tree_augroup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = neo_tree_augroup,
  pattern = "neo-tree",
  callback = function()
    local set_key = require("builtin.utils.keymap").set_key
    local opts = { buffer = true }
    set_key("n", "<leader>.", "<cmd>vertical resize +10<cr>", opts)
    set_key("n", "<leader>,", "<cmd>vertical resize -10<cr>", opts)
  end,
})

local sidebar_resizing = false
local function resize_sidebar()
  if sidebar_resizing then
    return
  end

  sidebar_resizing = true
  local neo_tree_filesystem = string.lower("neo-tree filesystem")
  local neo_tree_winnr = nil
  local tabnr = vim.api.nvim_get_current_tabpage()
  for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
    local bufnr = vim.api.nvim_win_get_buf(winnr)
    if vim.api.nvim_buf_is_valid(bufnr) then
      local bufname = vim.fn.bufname(bufnr)
      if
        string.len(bufname) >= string.len(neo_tree_filesystem)
        and string.sub(bufname, 1, #neo_tree_filesystem):lower() == neo_tree_filesystem
      then
        neo_tree_winnr = winnr
        break
      end
    end
  end
  if neo_tree_winnr then
    local new_width = layout.editor.width(
      constants.layout.sidebar.scale,
      constants.layout.sidebar.min,
      constants.layout.sidebar.max
    )
    vim.api.nvim_win_set_width(neo_tree_winnr, new_width)
  end
  vim.schedule(function()
    sidebar_resizing = false
  end)
end

vim.api.nvim_create_autocmd({ "VimResized", "UIEnter" }, {
  group = neo_tree_augroup,
  callback = resize_sidebar,
})

local function bootstrap()
  local function open_impl()
    local str = require("commons.str")

    local buftype = vim.bo.buftype
    local filename = vim.api.nvim_buf_get_name(0)
    -- print(string.format("buftype:%s, filename:%s", vim.inspect(buftype), vim.inspect(filename)))
    if str.not_empty(buftype) or str.not_empty(filename) then
      return
    end

    vim.cmd("Neotree")
    resize_sidebar()
  end
  vim.defer_fn(open_impl, 1)
end

bootstrap()
