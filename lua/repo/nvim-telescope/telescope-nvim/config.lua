local const = require("cfg.const")
local NO_BAT = vim.fn.executable("bat") <= 0

require("telescope").setup({
    defaults = {
        scroll_strategy = "limit",
        layout_config = {
            horizontal = {
                height = 0.9,
                width = 0.9,
                preview_width = 0.45,
            },
            vertical = {
                height = 0.9,
                width = 0.9,
                preview_width = 0.45,
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
                ["<C-l>"] = require("telescope.actions.layout").toggle_preview,

                ["<C-w>s"] = require("telescope.actions").select_horizontal,
                ["<C-x>"] = false, -- select_horizontal,
                ["<C-w>v"] = require("telescope.actions").select_vertical,
                ["<C-v>"] = false, -- select_vertical,
                ["<C-w>t"] = require("telescope.actions").select_tab,
                ["<C-t>"] = false, -- select_tab,

                ["<C-c>"] = false, -- actions.close
                ["<Tab>"] = false, -- actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = false, -- actions.toggle_selection + actions.move_selection_better,
                ["<C-q>"] = false, -- actions.send_to_qflist + actions.open_qflist,
                ["<M-q>"] = false, -- actions.send_selected_to_qflist + actions.open_qflist,
                ["<C-w>"] = false, -- { "<c-s-w>", type = "command" },
            },
            n = {
                ["<C-l>"] = require("telescope.actions.layout").toggle_preview,

                ["<C-w>s"] = require("telescope.actions").select_horizontal,
                ["<C-x>"] = false, -- select_horizontal,
                ["<C-w>v"] = require("telescope.actions").select_vertical,
                ["<C-v>"] = false, -- select_vertical,
                ["<C-w>t"] = require("telescope.actions").select_tab,
                ["<C-t>"] = false, -- select_tab,

                ["<Tab>"] = false, -- actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = false, -- actions.toggle_selection + actions.move_selection_better,
                ["<C-q>"] = false, -- actions.send_to_qflist + actions.open_qflist,
                ["<M-q>"] = false, --actions.send_selected_to_qflist + actions.open_qflist,,
            },
        },
        file_previewer = (const.os.is_windows or NO_BAT) and require(
            "telescope.previewers"
        ).vim_buffer_cat.new or require("telescope.previewers").cat.new,
        grep_previewer = (const.os.is_windows or NO_BAT) and require(
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
