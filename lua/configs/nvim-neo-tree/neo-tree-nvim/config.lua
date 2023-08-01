local constants = require("builtin.utils.constants")
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
    popup_border_style = constants.ui.border,
    default_component_configs = {
        icon = {
            folder_closed = "", -- nf-custom-folder \ue5ff
            folder_open = "", -- nf-custom-folder_open \ue5fe
            folder_empty = "", -- nf-cod-folder \uea83
            folder_empty_open = "", -- nf-cod-folder_opened \ueaf7
            default = "", -- nf-fa-file_text_o \uf0f6
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
    },
    renderers = {
        directory = {
            { "indent" },
            { "icon" },
            { "current_filter" },
            {
                "container",
                content = {
                    { "name", zindex = 10 },
                    {
                        "symlink_target",
                        zindex = 10,
                        highlight = "NeoTreeSymbolicLinkTarget",
                    },
                    { "clipboard", zindex = 10 },
                    {
                        "diagnostics",
                        errors_only = true,
                        zindex = 20,
                        align = "left",
                        hide_when_expanded = true,
                    },
                    {
                        "git_status",
                        zindex = 20,
                        align = "right",
                        hide_when_expanded = true,
                    },
                },
            },
        },
        file = {
            { "indent" },
            { "icon" },
            {
                "container",
                content = {
                    {
                        "name",
                        zindex = 10,
                    },
                    {
                        "symlink_target",
                        zindex = 10,
                        highlight = "NeoTreeSymbolicLinkTarget",
                    },
                    { "clipboard", zindex = 10 },
                    { "bufnr", zindex = 10 },
                    { "modified", zindex = 20, align = "left" },
                    { "diagnostics", zindex = 20, align = "left" },
                    { "git_status", zindex = 20, align = "right" },
                },
            },
        },
    },
    window = {
        width = layout.editor.width(
            constants.ui.layout.sidebar.scale,
            constants.ui.layout.sidebar.min,
            constants.ui.layout.sidebar.max
        ),
        mappings = {
            -- open node
            ["l"] = "open",
            -- close node
            ["h"] = function(state)
                local node = state.tree:get_node()
                if node.type == "directory" and node:is_expanded() then
                    require("neo-tree.sources.filesystem").toggle_directory(
                        state,
                        node
                    )
                else
                    require("neo-tree.ui.renderer").focus_node(
                        state,
                        node:get_parent_id()
                    )
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
            enabled = true,
            leave_dirs_open = true,
        },
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
vim.api.nvim_create_autocmd("VimEnter", {
    group = "neo_tree_augroup",
    callback = function(data)
        -- use defer_fn to open async
        local function open_impl()
            -- buffer is a [No Name]
            local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
            -- buffer is a directory
            local directory = vim.fn.isdirectory(data.file) == 1

            -- don't open neo-tree if opened buffer is a file
            if not no_name and not directory then
                return
            end

            -- change to the directory
            if directory then
                vim.cmd.cd(data.file)
            end

            -- open neo-tree
            vim.cmd("Neotree reveal")
        end
        vim.defer_fn(open_impl, 0)
    end,
})