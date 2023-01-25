local constants = require('conf/constants')

require("neo-tree").setup({
    popup_border_style = constants.ui.border,
    default_component_configs = {
        icon = {
            folder_closed = "", -- nf-fa-folder \uf07b
            folder_open = "", -- nf-fa-folder_open \uf07c
            folder_empty = "", -- nf-fa-folder_o \uf114
            folder_empty_open = "", -- nf-fa-folder_open_o \uf115
            default = "", -- nf-fa-file_o \uf016
        },
        git_status = {
            symbols = {
                -- Change type
                added     = "", -- nf-fa-plus \uf067
                modified  = "", -- nf-fa-circle \uf111
                deleted   = "", -- nf-fa-minus_square_o f147
                renamed   = "", -- nf-fa-arrow_right \uf061
                -- Status type
                untracked = "", -- nf-fa-question \uf128
                ignored   = "", -- nf-fa-circle_thin \uf1db
                unstaged  = "", -- disable unstaged, it's quite useless.
                staged    = "", -- nf-fa-edit \uf044
                conflict  = "", -- nf-dev-git_merge \ue727
            }
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
                    { "diagnostics", errors_only = true, zindex = 20, align = "left", hide_when_expanded = true }, -- move this indicator to left side
                    { "git_status", zindex = 20, align = "right", hide_when_expanded = true },
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
                        zindex = 10
                    },
                    {
                        "symlink_target",
                        zindex = 10,
                        highlight = "NeoTreeSymbolicLinkTarget",
                    },
                    { "clipboard", zindex = 10 },
                    { "bufnr", zindex = 10 },
                    { "modified", zindex = 20, align = "left" }, -- move this indicator to left side
                    { "diagnostics",  zindex = 20, align = "left" }, -- move this indicator to left side
                    { "git_status", zindex = 20, align = "right" },
                },
            },
        },
    },
    window = {
        mappings = {
            -- disabled mappings
            ["<space>"] = "",
            ["S"] = "",
            ["s"] = "",
            ["t"] = "",
            ["w"] = "",
            ["C"] = "",

            -- added mappings
            ["h"] = function(state)
                local node = state.tree:get_node()
                if node.type == 'directory' and node:is_expanded() then
                    require'neo-tree.sources.filesystem'.toggle_directory(state, node)
                else
                    require'neo-tree.ui.renderer'.focus_node(state, node:get_parent_id())
                end
            end,
            ["l"] = "open",
            ["<C-x>"] = "open_split",
            ["<C-v>"] = "open_vsplit",
            ["<C-t>"] = "open_tabnew",
            ["Z"] = "expand_all_nodes",
        },
    },
    filesystem = {
      filtered_items = {
        visible = true,
      },
      follow_current_file = true,
      window = {
        mappings = {
            -- diabled mappings
            ["[g"] = "",
            ["]g"] = "",

            -- added mappings
            ["[c"] = "prev_git_modified",
            ["]c"] = "next_git_modified",
        }
      }
    },
})
