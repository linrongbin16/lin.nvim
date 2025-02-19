require("blink.cmp").setup({
  completion = {
    list = {
      selection = {
        -- Use "auto_insert" for cmdline.
        auto_insert = function(ctx)
          return ctx.mode == "cmdline"
        end,
        -- Otherwise use "preselect".
        preselect = function(ctx)
          return ctx.mode ~= "cmdline"
        end,
      },
    },
    accept = { auto_brackets = { enabled = true } },
    documentation = { auto_show = true },
    menu = {
      draw = {
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
          { "source_name" },
        },
        components = {
          source_name = {
            width = { max = 10 },
            text = function(ctx)
              return "[" .. ctx.source_name .. "]"
            end,
            highlight = "BlinkCmpSource",
          },
        },
      },
    },
  },
  keymap = {
    ["<CR>"] = { "accept", "fallback" },

    -- Use <Tab> to accept if there are suggestions, jump to next placeholder if already in an expanded snippet.
    ["<Tab>"] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.accept()
        else
          return cmp.select_and_accept()
        end
      end,
      "snippet_forward",
      "fallback",
    },
    -- Use <S-Tab> to jump to previous placeholder if already in an expanded snippet.
    ["<S-Tab>"] = { "snippet_backward", "fallback" },

    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },
    ["<C-n>"] = { "select_next", "fallback" },

    ["<C-f>"] = { "snippet_forward", "fallback" },
    ["<C-b>"] = { "snippet_backward", "fallback" },

    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
  },
  signature = {
    enabled = true,
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "ripgrep" },
    providers = {
      ripgrep = {
        module = "blink-ripgrep",
        name = "RG",
        opts = {
          project_root_marker = {
            ".git", -- git
            "README.md", -- open source
            "LICENSE",
            ".editorconfig",
            ".vimrc", -- vim/nvim
            ".nvimrc",
            ".idea", -- jetbrains
            "Makefile", -- c/c++
            "CMakeLists.txt",
            "Cargo.toml", -- cargo/rust
            "webpack.config.js", -- webpack
            "package.json", -- nodejs
            "deno.json", -- deno
            "pom.xml", -- maven
            "build.gradle", -- gradle
            "pyproject.toml", -- python
            "go.mod", -- golang
            "go.sum",
            "Gemfile", -- ruby
            "Dockerfile", -- docker
            "composer.json", -- php
          },
          search_casing = "--case-sensitive",
          additional_rg_options = { "--max-depth=5", "--max-columns=1000", "--max-count=3000" },
        },
      },
    },
  },
  snippets = { preset = "luasnip" },
})
