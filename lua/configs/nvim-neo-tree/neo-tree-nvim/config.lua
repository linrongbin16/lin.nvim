local constants = require("builtin.constants")
local layout = require("builtin.utils.layout")

local function trash_bin(state)
  local inputs = require("neo-tree.ui.inputs")
  local path = state.tree:get_node().path
  local msg = "Are you sure you want to move '"
    .. vim.fn.fnamemodify(vim.fn.fnameescape(path), ":~:.")
    .. "' to trash bin?"
  inputs.confirm(msg, function(confirmed)
    if not confirmed then
      return
    end
    vim.fn.system({ "trash", vim.fn.fnameescape(path) })
    require("neo-tree.sources.manager").refresh(state.name)
  end)
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
    symlink_target = {
      enabled = true,
    },
  },
  window = {
    width = layout.editor.width(
      constants.window.layout.sidebar.scale,
      constants.window.layout.sidebar.min,
      constants.window.layout.sidebar.max
    ),
    mappings = {
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
      ["C"] = "none",
      ["<space>"] = "none",
      ["w"] = "none",

      -- open in split/vsplit/tab
      ["<C-w>s"] = "open_split",
      ["<C-w>v"] = "open_vsplit",
      ["<C-w>t"] = "open_tabnew",
      ["S"] = "none",
      ["s"] = "none",
      ["t"] = "none",

      -- preview
      ["<C-l>"] = { "toggle_preview", config = { use_float = true } },
      ["P"] = "none",

      -- expand/collapse
      ["W"] = "close_all_nodes",
      ["E"] = "expand_all_nodes",
      ["z"] = "none",
      ["e"] = "none",

      -- delete
      ["d"] = vim.fn.executable("trash") > 0 and trash_bin or "delete",
    },
  },
  filesystem = {
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
        ["f"] = "fuzzy_finder",
        ["<C-f>"] = "clear_filter",
        ["<C-x>"] = "none",
        ["/"] = "none",
        ["#"] = "none",
        ["<C-]>"] = "set_root",
        ["[c"] = "prev_git_modified",
        ["]c"] = "next_git_modified",
        ["D"] = "delete",
      },
    },
  },
})

vim.api.nvim_create_augroup("neo_tree_augroup", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = "neo_tree_augroup",
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
      constants.window.layout.sidebar.scale,
      constants.window.layout.sidebar.min,
      constants.window.layout.sidebar.max
    )
    vim.api.nvim_win_set_width(neo_tree_winnr, new_width)
  end
  vim.schedule(function()
    sidebar_resizing = false
  end)
end

vim.api.nvim_create_autocmd({ "VimResized", "UIEnter" }, {
  group = "neo_tree_augroup",
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
