local function require_init(url)
    require(string.format('repo/%s/init', string.gsub(url, '%.', '-')))
end

local function require_config(url)
    require(string.format('repo/%s/config', string.gsub(url, '%.', '-')))
end

local function source_init(url)
    vim.cmd(string.format('source $HOME/.vim/repo/%s/init.vim', url))
end

local function source_config(url)
    vim.cmd(string.format('source $HOME/.vim/repo/%s/config.vim', url))
end

-- ---- Plugins Header ----

return {

    -- ---- Infrastructure ----
    'wbthomason/packer.nvim',
    {
        'nathom/filetype.nvim',
        init = function()
            require_init('nathom/filetype.nvim')
        end
    },
    'lewis6991/impatient.nvim',
    'neovim/nvim-lspconfig',
    'dstein64/vim-startuptime',

    -- ---- Colorscheme ----
    'bluz71/vim-nightfly-colors',
    'bluz71/vim-moonfly-colors',
    { 'catppuccin/nvim', name = 'catppuccin' },
    { 'challenger-deep-theme/vim', name = 'challenger-deep' },
    'cocopon/iceberg.vim',
    'EdenEast/nightfox.nvim',
    { 'embark-theme/vim', name = 'embark' },
    'fenetikm/falcon',
    { 'folke/tokyonight.nvim', branch = 'main' },
    -- inherit 'lifepillar/vim-solarized8'
    'ishan9299/nvim-solarized-lua',
    {
        'junegunn/seoul256.vim',
        init = function()
            source_init('junegunn/seoul256.vim')
        end
    },
    -- inherit sainnhe/gruvbox-material
    { 'luisiacc/gruvbox-baby', branch = 'main' },
    -- inherit kaicataldo/material.vim
    'marko-cerovac/material.nvim',
    'mhartington/oceanic-next',
    -- inherit dracula/vim
    'Mofiqul/dracula.nvim',
    -- inherit joshdick/onedark.vim, tomasiser/vim-code-dark, olimorris/onedarkpro.nvim
    'navarasu/onedark.nvim',
    'NLKNguyen/papercolor-theme',
    { 'pineapplegiant/spaceduck', branch = 'main' },
    'preservim/vim-colors-pencil',
    'projekt0n/github-nvim-theme',
    'raphamorim/lucario',
    'rebelot/kanagawa.nvim',
    'Rigellute/rigel',
    'romainl/Apprentice',
    { 'rose-pine/neovim', name = 'rose-pine' },
    'sainnhe/edge',
    'sainnhe/everforest',
    -- inherit sickill/vim-monokai
    'sainnhe/sonokai',
    'shaunsingh/nord.nvim',
    'srcery-colors/srcery-vim',

    -- ---- Highlight ----
    {
        'RRethy/vim-illuminate',
        init = function()
            require_init('RRethy/vim-illuminate')
        end,
        config = function()
            source_config('RRethy/vim-illuminate')
        end
    },
    {
        'NvChad/nvim-colorizer.lua',
        event = 'VeryLazy',
        config = function()
            require_config('NvChad/nvim-colorizer.lua')
        end
    },
    'andymass/vim-matchup',
    {
        'inkarkat/vim-mark',
        dependencies = { 'inkarkat/vim-ingo-library' },
        init = function()
            source_init('inkarkat/vim-mark')
        end,
        config = function()
            source_config('inkarkat/vim-mark')
        end
    },

    -- ---- UI ----
    -- File explorer
    -- {
    --     'nvim-neo-tree/neo-tree.nvim',
    --     branch = 'v2.x',
    --     dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
    --     config = function()
    --         require_config('nvim-neo-tree/neo-tree.nvim')
    --         source_config('nvim-neo-tree/neo-tree.nvim')
    --     end
    -- },
    {
        'nvim-tree/nvim-tree.lua', 
        dependencies = { 'nvim-tree/nvim-web-devicons' }, 
        config = function()
            require_config('nvim-tree/nvim-tree.lua')
            source_config('nvim-tree/nvim-tree.lua')
        end
    },
    -- Tabline
    {
        'akinsho/bufferline.nvim',
        version = 'v3.*',
        dependencies = { "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim" },
        config = function()
            require_config('akinsho/bufferline.nvim')
            source_config('akinsho/bufferline.nvim')
        end
    },
    -- Indentline
    'lukas-reineke/indent-blankline.nvim',
    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require_config('nvim-lualine/lualine.nvim')
        end
    },
    {
        'nvim-lua/lsp-status.nvim',
        config = function()
            require_config('nvim-lua/lsp-status.nvim')
        end
    },
    -- Git
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require_config('lewis6991/gitsigns.nvim')
            source_config('lewis6991/gitsigns.nvim')
        end
    },
    -- Terminal
    {
        'akinsho/toggleterm.nvim',
        version = '*',
        config = function()
            require_config('akinsho/toggleterm.nvim')
        end
    },
    -- UI hooks
    {
        'stevearc/dressing.nvim',
        config = function()
            require_config('stevearc/dressing.nvim')
        end
    },
    -- Smooth scrolling
    'karb94/neoscroll.nvim',
    -- Structures/Outlines
    'liuchengxu/vista.vim',
    {
        'ludovicchabant/vim-gutentags',
        init = function()
            source_init('ludovicchabant/vim-gutentags')
        end
    },

    -- ---- Search ----
    { 'junegunn/fzf', build = ':call fzf#install()' },
    {
        'junegunn/fzf.vim',
        init = function()
            source_init('junegunn/fzf.vim')
        end,
        config = function()
            source_config('junegunn/fzf.vim')
        end
    },
    {
        'ojroques/nvim-lspfuzzy',
        config = function()
            require_config('ojroques/nvim-lspfuzzy')
        end
    },

    -- ---- LSP server ----
    {
        'williamboman/mason.nvim',
        config = function()
            require_config('williamboman/mason.nvim')
        end
    },
    'williamboman/mason-lspconfig.nvim',
    { 'jose-elias-alvarez/null-ls.nvim', dependencies = { "nvim-lua/plenary.nvim" } },
    'jay-babu/mason-null-ls.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    {
        'hrsh7th/nvim-cmp',
        config = function()
            require_config('hrsh7th/nvim-cmp')
            source_config('hrsh7th/nvim-cmp')
        end
    },
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',

    -- ---- Language support ----
    -- Markdown
    {
        'iamcco/markdown-preview.nvim',
        build = 'cd app && npm install',
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { 'markdown' }
    },
    -- Clangd extension
    'p00f/clangd_extensions.nvim',
    -- Lex/yacc, flex/bison
    { 'justinmk/vim-syntax-extra', ft = { "lex", "flex", "yacc", "bison" } },
    -- LLVM
    {
        'rhysd/vim-llvm',
        ft = { "llvm", "mir", "mlir", "tablegen" },
        init = function()
            source_init('rhysd/vim-llvm')
        end
    },
    -- Hive
    { 'zebradil/hive.vim', ft = { "hive" } },
    -- Slim
    { 'slim-template/vim-slim', ft = { "slim" } },

    -- ---- Movement ----
    -- Cursor Movement
    {
        'phaazon/hop.nvim',
        branch = 'v2',
        config = function()
            require_config('phaazon/hop.nvim')
            source_config('phaazon/hop.nvim')
        end
    },
    {
        'ggandor/leap.nvim',
        dependencies = { "tpope/vim-repeat" },
        config = function()
            require_config('ggandor/leap.nvim')
        end
    },
    {
        'chaoren/vim-wordmotion',
        init = function()
            source_init('chaoren/vim-wordmotion')
        end,
        config = function()
            source_config('chaoren/vim-wordmotion')
        end
    },

    -- ---- Editing enhancement ----
    -- HTML tag
    {
        'alvan/vim-closetag',
        init = function()
            source_init('alvan/vim-closetag')
        end
    },
    -- Comment
    {
        'numToStr/Comment.nvim',
        config = function()
            require_config('numToStr/Comment.nvim')
        end
    },
    -- Autopair
    {
        'windwp/nvim-autopairs',
        config = function()
            require_config('windwp/nvim-autopairs')
        end
    },
    -- Incremental search
    'haya14busa/is.vim',
    -- Other
    'tpope/vim-repeat',
    'mbbill/undotree',
    'editorconfig/editorconfig-vim',
}

-- ---- Plugins Footer ----
