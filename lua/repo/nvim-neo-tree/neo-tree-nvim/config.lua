local const = require("cfg.const")

require("neo-tree").setup({
    popup_border_style = const.ui.border,
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
                added = "", -- : nf-fa-plus \uf067
                modified = "", -- : nf-fa-circle \uf111
                deleted = "", -- nf-fa-times \uf00d
                renamed = "", -- nf-fa-arrow_right \uf061
                -- Status type
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
                    }, -- move this indicator to left side
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
                    { "modified", zindex = 20, align = "left" }, -- move this indicator to left side
                    { "diagnostics", zindex = 20, align = "left" }, -- move this indicator to left side
                    { "git_status", zindex = 20, align = "right" },
                },
            },
        },
    },
    window = {
        mappings = {
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
            ["l"] = "open",
            ["<space>"] = "none",
            ["w"] = "none",

            ["s"] = "open_split",
            ["v"] = "open_vsplit",
            ["t"] = "open_tabnew",

            ["W"] = "close_all_nodes",
            ["E"] = "expand_all_nodes",
            ["z"] = "none",

            ["e"] = "none",
        },
    },
    filesystem = {
        filtered_items = {
            visible = true,
        },
        follow_current_file = true,
        use_libuv_file_watcher = true,
    },
})

vim.api.nvim_create_augroup("neo_tree_augroup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "neo_tree_augroup",
    pattern = "neo-tree",
    callback = function()
        local map = require("cfg.keymap").map
        local opts = { buffer = true }
        map("n", "<leader>.", "<cmd>vertical resize +10<cr>", opts)
        map("n", "<leader>,", "<cmd>vertical resize -10<cr>", opts)
    end,
})
vim.api.nvim_create_autocmd("VimEnter", {
    group = "neo_tree_augroup",
    callback = function()
        vim.cmd("Neotree reveal")
    end,
})
