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
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "-H", -- --with-filename,
            "-n", -- --line-number
            "--column",
            "-S", -- --smart-case,
        },
        set_env = {
            BAT_THEME = "ansi",
            BAT_STYLE = "numbers,changes",
        },
        dynamic_preview_title = true,
        mappings = {
            i = {
                ["<C-s>"] = require("telescope.actions").select_horizontal,
                ["<C-x>"] = false,
                ["<C-l>"] = require("telescope.actions.layout").toggle_preview,
            },
            n = {
                ["<C-s>"] = require("telescope.actions").select_horizontal,
                ["<C-x>"] = false,
                ["<C-l>"] = require("telescope.actions.layout").toggle_preview,
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
            override_generic_sorter = false, -- don't fuzzy on live_grep/grep_string
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
