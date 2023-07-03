local constants = require("builtin.utils.constants")
local BAT_PREVIEWER = not constants.os.is_windows
    and vim.fn.executable("bat") > 0
    and vim.fn.executable("less") > 0
local LAYOUT_CONFIG = {
    FILE = {
        height = 0.9,
        width = 0.9,
        preview_width = 0.5,
        prompt_position = "top",
    },
    CENTER = {
        height = 0.7,
        width = 0.7,
        preview_cutoff = 80,
    },
}

require("telescope").setup({
    defaults = {
        scroll_strategy = "limit",
        sorting_strategy = "ascending",
        layout_config = {
            bottom_pane = {
                height = 25,
                preview_cutoff = 120,
                prompt_position = "top",
            },
            horizontal = LAYOUT_CONFIG.FILE,
            vertical = LAYOUT_CONFIG.FILE,
            center = LAYOUT_CONFIG.CENTER,
            cursor = LAYOUT_CONFIG.FILE,
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
                -- preview
                ["<C-l>"] = require("telescope.actions.layout").toggle_preview,

                -- open in split/vsplit/tab
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
                -- preview
                ["<C-l>"] = require("telescope.actions.layout").toggle_preview,

                -- open in split/vsplit/tab
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

                -- quit
                ["<ESC>"] = require("telescope.actions").close,
                ["<C-c>"] = require("telescope.actions").close,
                ["<C-[>"] = require("telescope.actions").close,
                ["q"] = require("telescope.actions").close,
                ["Q"] = require("telescope.actions").close,
            },
        },
        file_previewer = BAT_PREVIEWER
                and require("telescope.previewers").cat.new
            or require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = BAT_PREVIEWER
                and require("telescope.previewers").vimgrep.new
            or require("telescope.previewers").vim_buffer_vimgrep.new,
    },
    pickers = {
        buffers = {
            mappings = {
                n = {
                    -- delete buffer
                    ["<C-x>"] = require("telescope.actions").delete_buffer,
                    ["dd"] = require("telescope.actions").delete_buffer,
                },
                i = {
                    -- delete buffer
                    ["<C-x>"] = require("telescope.actions").delete_buffer,
                },
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
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
require("telescope").load_extension("undo")