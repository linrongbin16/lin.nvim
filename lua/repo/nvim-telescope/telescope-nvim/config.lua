local const = require("cfg.const")

require("telescope").setup({
    defaults = {
        layout_config = {
            preview_width = 0.5,
            horizontal = {
                height = 0.9,
                width = 0.9,
            },
            vertical = {
                height = 0.9,
                width = 0.9,
            },
        },
        set_env = {
            BAT_THEME = "ansi",
            BAT_STYLE = "numbers,changes",
        },
        dynamic_preview_title = true,
        default_mappings = {
            i = {
                ["<CR>"] = require("telescope.actions").select_default,
                ["<C-s>"] = require("telescope.actions").select_horizontal,
                ["<C-v>"] = require("telescope.actions").select_vertical,
                ["<C-t>"] = require("telescope.actions").select_tab,
                ["<Esc>"] = require("telescope.actions").close,
                ["<C-l>"] = require("telescope.actions.layout").toggle_preview,
                ["<C-n>"] = require("telescope.actions").move_selection_next,
                ["<C-p>"] = require("telescope.actions").move_selection_previous,
                ["<Down>"] = require("telescope.actions").move_selection_next,
                ["<Up>"] = require("telescope.actions").move_selection_previous,
            },
            n = {
                ["<CR>"] = require("telescope.actions").select_default,
                ["<C-s>"] = require("telescope.actions").select_horizontal,
                ["<C-v>"] = require("telescope.actions").select_vertical,
                ["<C-t>"] = require("telescope.actions").select_tab,
                ["<Esc>"] = require("telescope.actions").close,
                ["<C-l>"] = require("telescope.actions.layout").toggle_preview,
                ["j"] = require("telescope.actions").move_selection_next,
                ["k"] = require("telescope.actions").move_selection_previous,
                ["<C-n>"] = require("telescope.actions").move_selection_next,
                ["<C-p>"] = require("telescope.actions").move_selection_previous,
                ["<Down>"] = require("telescope.actions").move_selection_next,
                ["<Up>"] = require("telescope.actions").move_selection_previous,
            },
        },
        file_previewer = const.os.is_windows and require(
            "telescope.previewers"
        ).vim_buffer_cat.new or require("telescope.previewers").cat.new,
        grep_previewer = const.os.is_windows and require(
            "telescope.previewers"
        ).vim_buffer_vimgrep.new or require("telescope.previewers").vimgrep.new,
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = false,
            override_file_sorter = true,
            case_mode = "ignore_case",
        },
        live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            mappings = { -- extend mappings
                i = {
                    ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                    ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({
                        postfix = " --iglob ",
                    }),
                },
            },
        },
    },
})

require("telescope").load_extension("fzf")
