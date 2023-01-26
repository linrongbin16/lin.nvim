#!/usr/bin/env python3

import abc
import datetime
import enum
import pathlib
import platform

import click

HOME_DIR = pathlib.Path.home()
VIM_DIR = pathlib.Path(f"{HOME_DIR}/.vim")
TEMPLATE_DIR = pathlib.Path(f"{HOME_DIR}/.vim/temp")
INIT_FILE = pathlib.Path(f"{VIM_DIR}/init.vim")

IS_WINDOWS = platform.system().lower().startswith("win")
IS_MACOS = platform.system().lower().startswith("darwin")


def message(*args):
    print(f"[lin.vim] - {' '.join(args)}")


def error_message(*args):
    print(f"[lin.vim] - error! {' '.join(args)}")


def try_backup(src):
    assert isinstance(src, pathlib.Path)
    if src.is_symlink() or src.exists():
        dest = f"{src}.{datetime.datetime.now().strftime('%Y-%m-%d.%H-%M-%S.%f')}"
        src.rename(dest)
        message(f"backup '{src}' to '{dest}'")


INDENT_SIZE = 4


# class Indentable:
#     def __init__(self):
#         self._value = 0
#
#     @property
#     def indentlevel(self):
#         return self._value
#
#     def inc_indentlevel(self):
#         self._value += 1
#
#     def dec_indentlevel(self):
#         self._value = max(self._value - 1, 0)
#
#     def get_dec_indentlevel(self):
#         return max(self._value - 1, 0)


# Vim AST {


class Expr(abc.ABC):
    @abc.abstractmethod
    def render(self):
        pass


class StringExpr(Expr):
    @abc.abstractmethod
    def render(self):
        pass


class SingleQuoteStringExpr(StringExpr):
    def __init__(self, value):
        self.value = value

    def render(self):
        return f"'{str(self.value)}'"


class DoubleQuotesStringExpr(StringExpr):
    def __init__(self, value):
        self.value = value

    def render(self):
        return f'"{str(self.value)}"'


class LiteralExpr(Expr):
    def __init__(self, value):
        self.value = value

    def render(self):
        return str(self.value)


class SourceExpr(Expr):
    def __init__(self, expr):
        assert isinstance(expr, LiteralExpr)
        self.expr = expr

    def render(self):
        return f"source {self.expr.render()}"


class CommentExpr(Expr):
    def __init__(self, expr):
        assert isinstance(expr, Expr)
        self.expr = expr

    def render(self):
        return f'" {self.expr.render()}'


class EmptyCommentExpr(CommentExpr):
    def __init__(self):
        CommentExpr.__init__(self, LiteralExpr("Empty"))


class FunctionInvokeExpr(Expr):
    def __init__(self, func, *args) -> None:
        assert isinstance(func, LiteralExpr)
        if args:
            for a in args:
                assert isinstance(a, LiteralExpr)
        self.func = func
        self.args = args if args else []

    def render(self):
        return f"{self.func.render()}({','.join([e.render() for e in self.args])})"


class CallExpr(Expr):
    def __init__(self, expr):
        assert isinstance(expr, Expr)
        self.expr = expr

    def render(self):
        return f"call {self.expr.render()}"


class AddExpr(Expr):
    def __init__(self, *args) -> None:
        assert args
        for a in args:
            assert isinstance(a, Expr)
        self.args = args

    def render(self):
        return f"add({', '.join([a.render() for a in self.args])})"


class ColorschemeExpr(Expr):
    def __init__(self, expr):
        assert isinstance(expr, LiteralExpr)
        self.expr = expr

    def render(self):
        return f"colorscheme {self.expr.render()}"


class IndentExpr(Expr):
    def __init__(self, expr, count=1):
        assert isinstance(expr, Expr)
        assert isinstance(count, int) and count >= 0
        self.expr = expr
        self.count = count

    def render(self):
        return f"{' ' * self.count * INDENT_SIZE}{self.expr.render()}"


class LineContinuationExpr(Expr):
    def __init__(self, expr):
        assert isinstance(expr, Expr)
        self.expr = expr

    def render(self):
        return f"\\ {self.expr.render()}"


class CommaExpr(Expr):
    def __init__(self, expr):
        assert isinstance(expr, Expr)
        self.expr = expr

    def render(self):
        return f"{self.expr.render()},"


class Stmt(Expr):
    def __init__(self, expr=None):
        assert isinstance(expr, Expr) or expr is None
        self.expr = expr

    def render(self):
        return f"{self.expr.render() if self.expr else ''}\n"


class EmptyStmt(Stmt):
    def __init__(self):
        Stmt.__init__(self, None)


class TemplateContent(Expr):
    def __init__(self, path):
        assert isinstance(path, pathlib.Path)
        assert path.exists()
        with open(path, "r") as fp:
            self.content = fp.read()

    def render(self):
        return self.content


class SourceStmtFromVimHome(Expr):
    def __init__(self, value):
        self.stmt = Stmt(SourceExpr(LiteralExpr(f"$HOME/.vim/{value}")))

    def render(self):
        return self.stmt.render()


class LuaExpr(Expr):
    def __init__(self, expr):
        assert isinstance(expr, Expr)
        self.expr = expr

    def render(self):
        return f"lua {self.expr.render()}"


class HackNerdFontExpr(Expr):
    def __init__(self):
        pass

    def render(self):
        if IS_WINDOWS:
            return "set guifont=Hack\\ NFM:h10"
        elif IS_MACOS:
            return "set guifont=Hack\\ Nerd\\ Font\\ Mono:h13"
        else:
            # Linux
            return "set guifont=Hack\\ Nerd\\ Font\\ Mono:h10"


class RequireExpr(Expr):
    def __init__(self, expr) -> None:
        assert isinstance(expr, StringExpr)
        self.expr = expr

    def render(self):
        return f"require({self.expr.render()})"


class LuaRequireStmt(Expr):
    def __init__(self, expr):
        self.expr = Stmt(LuaExpr(RequireExpr(SingleQuoteStringExpr(expr))))

    def render(self):
        return self.expr.render()


class Exprs(Expr):
    def __init__(self, exprs, delimiter=""):
        assert isinstance(delimiter, str)
        assert isinstance(exprs, list)
        for e in exprs:
            assert isinstance(e, Expr)
        self.exprs = exprs
        self.delimiter = delimiter

    def render(self):
        return self.delimiter.join([e.render() for e in self.exprs])


# }

# Lua AST {


class CommentExpr4Lua(Expr):
    def __init__(self, expr):
        assert isinstance(expr, Expr)
        self.expr = expr

    def render(self):
        return f"-- {self.expr.render()}"


class EmptyCommentExpr4Lua(CommentExpr4Lua):
    def __init__(self):
        CommentExpr4Lua.__init__(self, LiteralExpr("Empty"))


class LazySpecExpr4Lua(Expr):
    def __init__(self, org, repo, prop=None):
        assert isinstance(org, Expr)
        assert isinstance(repo, Expr)
        assert isinstance(prop, Expr) or prop is None
        self.org = org
        self.repo = repo
        self.prop = prop

    def render(self):
        if not self.prop:
            return f"'{self.org.render()}/{self.repo.render()}'"
        else:
            return f"{{ '{self.org.render()}/{self.repo.render()}', {self.prop.render()} }}"


def to_lua(expr):
    assert isinstance(expr, Expr)
    if isinstance(expr, Stmt):
        return expr
    if isinstance(expr, CommentExpr):
        return CommentExpr4Lua(expr.expr)


# }


class Tag(enum.Enum):
    COLORSCHEME = 1
    HIGHLIGHT = 2
    LANGUAGE = 3
    EDITING = 4
    INFRASTRUCTURE = 5


class Plugin:
    def __init__(
        self,
        org,
        repo,
        prop=None,
        above=None,
        color=None,
        tag=None,
    ) -> None:
        self.org = org
        self.repo = repo
        self.prop = prop  # more plugin properties following this line
        self.above = above  # more clauses above this line
        self.color = color
        self.tag = tag

    def __str__(self):
        return f"{self.org}/{self.repo}"


PLUGINS = [
    # Infrastructure
    Plugin(
        "wbthomason",
        "packer.nvim",
        above=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Infrastructure ----")),
        ],
        tag=Tag.INFRASTRUCTURE,
    ),
    Plugin(
        "nathom",
        "filetype.nvim",
        tag=Tag.INFRASTRUCTURE,
    ),
    Plugin(
        "neovim",
        "nvim-lspconfig",
        tag=Tag.INFRASTRUCTURE,
    ),
    # Colorscheme
    Plugin(
        "bluz71",
        "vim-nightfly-colors",
        prop=("lazy", "true"),
        above=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Colorscheme ----")),
        ],
        color="nightfly",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "bluz71",
        "vim-moonfly-colors",
        prop=("lazy", "true"),
        color="moonfly",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "catppuccin",
        "nvim",
        prop=[("name", "'catppuccin'"), ("lazy", "true")],
        color="catppuccin",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "challenger-deep-theme",
        "vim",
        prop=[("name", "'challenger-deep'"), ("lazy", "true")],
        color="challenger_deep",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "cocopon",
        "iceberg.vim",
        prop=("lazy", "true"),
        color="iceberg",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "EdenEast",
        "nightfox.nvim",
        prop=("lazy", "true"),
        color="nightfox",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "embark-theme",
        "vim",
        prop=[("name", "'embark'"), ("lazy", "true")],
        color="embark",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "fenetikm",
        "falcon",
        prop=("lazy", "true"),
        color="falcon",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "folke",
        "tokyonight.nvim",
        prop=[("branch", "'main'"), ("lazy", "true")],
        color="tokyonight",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "ishan9299",
        "nvim-solarized-lua",
        prop=("lazy", "true"),
        above=CommentExpr(LiteralExpr("inherit 'lifepillar/vim-solarized8'")),
        color="solarized",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "junegunn",
        "seoul256.vim",
        prop=("lazy", "true"),
        color="seoul256",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "luisiacc",
        "gruvbox-baby",
        prop=[("branch", "'main'"), ("lazy", "true")],
        above=CommentExpr(LiteralExpr("inherit sainnhe/gruvbox-material")),
        color="gruvbox-baby",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "marko-cerovac",
        "material.nvim",
        prop=("lazy", "true"),
        above=CommentExpr(LiteralExpr("inherit kaicataldo/material.vim")),
        color="material",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "mhartington",
        "oceanic-next",
        prop=("lazy", "true"),
        color="OceanicNext",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "Mofiqul",
        "dracula.nvim",
        prop=("lazy", "true"),
        above=CommentExpr(LiteralExpr("inherit dracula/vim")),
        color="dracula",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "navarasu",
        "onedark.nvim",
        prop=("lazy", "true"),
        above=CommentExpr(
            LiteralExpr(
                "inherit joshdick/onedark.vim, tomasiser/vim-code-dark, olimorris/onedarkpro.nvim"
            )
        ),
        color="onedark",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "NLKNguyen",
        "papercolor-theme",
        prop=("lazy", "true"),
        color="PaperColor",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "pineapplegiant",
        "spaceduck",
        color="spaceduck",
        prop=[("branch", "'main'"), ("lazy", "true")],
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "preservim",
        "vim-colors-pencil",
        prop=("lazy", "true"),
        color="pencil",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "projekt0n",
        "github-nvim-theme",
        prop=("lazy", "true"),
        color="github_dark",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "raphamorim",
        "lucario",
        prop=("lazy", "true"),
        color="lucario",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "rebelot",
        "kanagawa.nvim",
        prop=("lazy", "true"),
        color="kanagawa",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "Rigellute", "rigel", color="rigel", prop=("lazy", "true"), tag=Tag.COLORSCHEME
    ),
    Plugin(
        "romainl",
        "Apprentice",
        prop=("lazy", "true"),
        color="apprentice",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "rose-pine",
        "neovim",
        color="rose-pine",
        prop=[("name", "'rose-pine'"), ("lazy", "true")],
        tag=Tag.COLORSCHEME,
    ),
    Plugin("sainnhe", "edge", prop=("lazy", "true"), color="edge", tag=Tag.COLORSCHEME),
    Plugin(
        "sainnhe",
        "everforest",
        prop=("lazy", "true"),
        color="everforest",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "sainnhe",
        "sonokai",
        prop=("lazy", "true"),
        above=CommentExpr(LiteralExpr("inherit sickill/vim-monokai")),
        color="sonokai",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "shaunsingh",
        "nord.nvim",
        prop=("lazy", "true"),
        color="nord",
        tag=Tag.COLORSCHEME,
    ),
    # onehalfdark not working on windows
    # Plugin(
    #     "sonph",
    #     "onehalf",
    #     follow="rtp = 'vim/'",
    #     color="onehalfdark",
    #     tag=Tag.COLORSCHEME,
    # ),
    Plugin(
        "srcery-colors",
        "srcery-vim",
        prop=("lazy", "true"),
        color="srcery",
        tag=Tag.COLORSCHEME,
    ),
    # Highlight
    Plugin(
        "RRethy",
        "vim-illuminate",
        prop=("event", "'VeryLazy'"),
        above=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Highlight ----")),
        ],
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        "NvChad",
        "nvim-colorizer.lua",
        prop=("event", "'VeryLazy'"),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        "andymass",
        "vim-matchup",
        prop=("event", "'VeryLazy'"),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        "inkarkat",
        "vim-mark",
        prop=[
            ("dependencies", "{ 'inkarkat/vim-ingo-library' }"),
            ("event", "'VeryLazy'"),
        ],
        tag=Tag.HIGHLIGHT,
    ),
    # Plugin(
    #     "nvim-neo-tree",
    #     "neo-tree.nvim",
    #     prop=[
    #         ("branch", "'v2.x'"),
    #         (
    #             "dependencies",
    #             "{ 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' }",
    #         ),
    #     ],
    #     above=[
    #         EmptyStmt(),
    #         CommentExpr(LiteralExpr("---- UI ----")),
    #         CommentExpr(LiteralExpr("File explorer")),
    #     ],
    # ),
    Plugin(
        "nvim-tree",
        "nvim-tree.lua",
        prop=("dependencies", "{ 'nvim-tree/nvim-web-devicons' }"),
        above=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- UI ----")),
            CommentExpr(LiteralExpr("File explorer")),
        ],
    ),
    Plugin(
        "akinsho",
        "bufferline.nvim",
        prop=[
            ("version", "'v3.*'"),
            (
                "dependencies",
                '{ "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim"} ',
            ),
        ],
        above=CommentExpr(LiteralExpr("Tabline")),
    ),
    Plugin(
        "lukas-reineke",
        "indent-blankline.nvim",
        above=CommentExpr(LiteralExpr("Indentline")),
    ),
    Plugin(
        "nvim-lualine",
        "lualine.nvim",
        prop=("dependencies", '{ "nvim-tree/nvim-web-devicons" }'),
        above=CommentExpr(LiteralExpr("Statusline")),
    ),
    Plugin("nvim-lua", "lsp-status.nvim"),
    Plugin(
        "lewis6991",
        "gitsigns.nvim",
        above=CommentExpr(LiteralExpr("Git")),
    ),
    Plugin(
        "akinsho",
        "toggleterm.nvim",
        prop=[("version", "'*'"), ("event", "'VeryLazy'")],
        above=CommentExpr(LiteralExpr("Terminal")),
    ),
    Plugin(
        "stevearc",
        "dressing.nvim",
        above=CommentExpr(LiteralExpr("UI hooks")),
    ),
    Plugin(
        "karb94",
        "neoscroll.nvim",
        above=CommentExpr(LiteralExpr("Smooth scrolling")),
    ),
    Plugin(
        "liuchengxu",
        "vista.vim",
        prop=("event", "'VeryLazy'"),
        above=CommentExpr(LiteralExpr("Structures/Outlines")),
    ),
    Plugin("ludovicchabant", "vim-gutentags"),
    # Search
    Plugin(
        "junegunn",
        "fzf",
        prop=("build", "':call fzf#install()'"),
        above=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Search ----")),
        ],
    ),
    Plugin("junegunn", "fzf.vim"),
    Plugin("ojroques", "nvim-lspfuzzy"),
    # LSP server
    Plugin(
        "williamboman",
        "mason.nvim",
        above=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- LSP server ----")),
        ],
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "williamboman",
        "mason-lspconfig.nvim",
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "jose-elias-alvarez",
        "null-ls.nvim",
        prop=("dependencies", '{ "nvim-lua/plenary.nvim" }'),
        tag=Tag.LANGUAGE,
    ),
    Plugin("jay-babu", "mason-null-ls.nvim", tag=Tag.LANGUAGE),
    Plugin(
        "hrsh7th",
        "nvim-cmp",
        prop=[
            ("event", "{ 'InsertEnter', 'CmdlineEnter ' }"),
            (
                "dependencies",
                "{ 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' }",
            ),
        ],
        tag=Tag.LANGUAGE,
    ),
    # Plugin(
    #     "rafamadriz", "friendly-snippets", tag=Tag.LANGUAGE
    # ),
    # Language support
    Plugin(
        "iamcco",
        "markdown-preview.nvim",
        prop=[
            ("build", "'cd app && npm install'"),
            ("init", 'function() vim.g.mkdp_filetypes = { "markdown" } end'),
            ("ft", "{ 'markdown' }"),
        ],
        above=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Language support ----")),
            CommentExpr(LiteralExpr("Markdown")),
        ],
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "p00f",
        "clangd_extensions.nvim",
        above=CommentExpr(LiteralExpr("Clangd extension")),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "justinmk",
        "vim-syntax-extra",
        prop=("ft", '{ "lex", "flex", "yacc", "bison" }'),
        above=CommentExpr(LiteralExpr("Lex/yacc, flex/bison")),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "rhysd",
        "vim-llvm",
        prop=("ft", '{ "llvm", "mir", "mlir", "tablegen" }'),
        above=CommentExpr(LiteralExpr("LLVM")),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "zebradil",
        "hive.vim",
        prop=("ft", '{ "hive" }'),
        above=CommentExpr(LiteralExpr("Hive")),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "slim-template",
        "vim-slim",
        prop=("ft", '{ "slim" }'),
        above=CommentExpr(LiteralExpr("Slim")),
        tag=Tag.LANGUAGE,
    ),
    # Movement
    Plugin(
        "phaazon",
        "hop.nvim",
        prop=[("branch", "'v2'"), ("event", "'VeryLazy'")],
        above=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Movement ----")),
            CommentExpr(LiteralExpr("Cursor Movement")),
        ],
        tag=Tag.EDITING,
    ),
    Plugin(
        "ggandor",
        "leap.nvim",
        prop=[("dependencies", '{ "tpope/vim-repeat" }'), ("event", "'VeryLazy'")],
        tag=Tag.EDITING,
    ),
    Plugin("chaoren", "vim-wordmotion", prop=("event", "'VeryLazy'"), tag=Tag.EDITING),
    # Editing enhancement
    Plugin(
        "alvan",
        "vim-closetag",
        prop=("event", "'InsertEnter'"),
        above=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Editing enhancement ----")),
            CommentExpr(LiteralExpr("HTML tag")),
        ],
        tag=Tag.EDITING,
    ),
    Plugin(
        "numToStr",
        "Comment.nvim",
        prop=("event", "'VeryLazy'"),
        above=CommentExpr(LiteralExpr("Comment")),
        tag=Tag.EDITING,
    ),
    Plugin(
        "windwp",
        "nvim-autopairs",
        prop=("event", "'InsertEnter'"),
        above=CommentExpr(LiteralExpr("Autopair")),
        tag=Tag.EDITING,
    ),
    Plugin(
        "haya14busa",
        "is.vim",
        above=CommentExpr(LiteralExpr("Incremental search")),
        tag=Tag.EDITING,
    ),
    Plugin(
        "tpope",
        "vim-repeat",
        above=CommentExpr(LiteralExpr("Other")),
        tag=Tag.EDITING,
    ),
    Plugin("mbbill", "undotree", prop=("event", "'VeryLazy'"), tag=Tag.EDITING),
    Plugin(
        "editorconfig",
        "editorconfig-vim",
        prop=("event", "'VeryLazy'"),
        tag=Tag.EDITING,
    ),
]


class Render:
    def __init__(
        self,
        use_color=None,
        no_color=False,
        no_hilight=False,
        no_lang=False,
        no_edit=False,
        no_plugs=None,
        no_winctrl_opt=False,
    ):
        self.use_color = use_color
        self.no_color = no_color
        self.no_hilight = no_hilight
        self.no_lang = no_lang
        self.no_edit = no_edit
        self.no_plugs = no_plugs
        self.no_winctrl = no_winctrl_opt

    def render(self):
        gen_plugin_stmts, gen_colorscheme_stmts = self.generate()

        plugin_stmts = self.render_plugins(gen_plugin_stmts)
        lspserver_stmts = self.render_lspservers()
        colorscheme_stmts = self.render_colorschemes(gen_colorscheme_stmts)
        setting_stmts = self.render_settings()
        init_stmts = self.render_init()

        plugins = "".join([s.render() for s in plugin_stmts])
        lspservers = "".join([s.render() for s in lspserver_stmts])
        colorschemes = "".join([s.render() for s in colorscheme_stmts])
        settings = "".join([s.render() for s in setting_stmts])
        init = "".join([s.render() for s in init_stmts])
        return plugins, lspservers, colorschemes, settings, init

    # plugins.lua
    def render_plugins(self, core_plugins):
        stmts = []
        stmts.append(
            TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/plugins-template-header.lua"))
        )
        stmts.extend(core_plugins)
        stmts.append(
            TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/plugins-template-footer.lua"))
        )
        return stmts

    # init.vim
    def render_init(self):
        stmts = []
        stmts.append(TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/init-template.vim")))
        return stmts

    # lspservers.lua
    def render_lspservers(self):
        stmts = []
        if not self.no_lang:
            stmts.append(
                TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/lspservers-template.lua"))
            )
        return stmts

    # colorschemes.vim
    def render_colorschemes(self, core_color_settings):
        stmts = []
        stmts.append(
            TemplateContent(
                pathlib.Path(f"{TEMPLATE_DIR}/colorschemes-template-header.vim")
            )
        )
        stmts.extend(core_color_settings)
        stmts.append(
            TemplateContent(
                pathlib.Path(f"{TEMPLATE_DIR}/colorschemes-template-footer.vim")
            )
        )
        return stmts

    # settings.vim
    def render_settings(self):
        stmts = []
        stmts.extend(
            [
                EmptyStmt(),
                Stmt(CommentExpr(LiteralExpr("---- GUI Font ----"))),
                Stmt(HackNerdFontExpr()),
            ]
        )
        if self.use_color:
            stmts.extend(
                [
                    EmptyStmt(),
                    Stmt(CommentExpr(LiteralExpr("---- Static colorscheme ----"))),
                    Stmt(ColorschemeExpr(LiteralExpr(self.use_color))),
                ]
            )
        elif not self.no_color:
            stmts.extend(
                [
                    EmptyStmt(),
                    Stmt(
                        CommentExpr(
                            LiteralExpr("---- Random colorscheme on startup ----")
                        )
                    ),
                    Stmt(
                        CallExpr(FunctionInvokeExpr(LiteralExpr("LinNextRandomColor")))
                    ),
                ]
            )
        if not self.no_winctrl:
            stmts.append(
                TemplateContent(
                    pathlib.Path(f"{TEMPLATE_DIR}/winctrl-settings-template.vim")
                )
            )
        stmts.append(
            TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/settings-template.vim"))
        )
        return stmts

    def generate(self):
        plugins = []
        colorschemes = []
        for ctx in PLUGINS:
            assert isinstance(ctx, Plugin)
            # above
            if ctx.above:
                aboves = ctx.above if isinstance(ctx.above, list) else [ctx.above]
                for a in aboves:
                    assert isinstance(a, Expr)
                    if isinstance(a, EmptyStmt):
                        plugins.append(to_lua(a))
                    elif isinstance(a, CommentExpr):
                        plugins.append(Stmt(IndentExpr(to_lua(a))))
                    else:
                        assert False
            # body
            if not self.is_disabled(ctx):
                # plugins
                prop = self.assemble_props(ctx)
                lua_base = f"repo/{str(ctx).replace('.', '-')}"
                lua_init = f"{lua_base}/init"
                lua_init_file = f"{VIM_DIR}/lua/{lua_init}.lua"
                lua_config = f"{lua_base}/config"
                lua_config_file = f"{VIM_DIR}/lua/{lua_config}.lua"
                vim_base = f"repo/{ctx}"
                vim_init = f"{vim_base}/init.vim"
                vim_init_file = f"{VIM_DIR}/{vim_init}"
                vim_config = f"{vim_base}/config.vim"
                vim_config_file = f"{VIM_DIR}/{vim_config}"

                # init
                inits = []
                if pathlib.Path(lua_init_file).exists():
                    inits.append(RequireExpr(SingleQuoteStringExpr(lua_init)).render())
                if pathlib.Path(vim_init_file).exists():
                    init_source = SourceExpr(LiteralExpr(f"$HOME/.vim/{vim_init}"))
                    inits.append(f"vim.cmd('{init_source.render()}')")
                if len(inits) > 0:
                    rendered_inits = "\n".join(inits)
                    prop.append(
                        LiteralExpr(
                            f"""init = function()
        {rendered_inits}
    end"""
                        )
                    )

                # config
                configs = []
                if pathlib.Path(lua_config_file).exists():
                    configs.append(
                        RequireExpr(SingleQuoteStringExpr(lua_config)).render()
                    )
                if pathlib.Path(vim_config_file).exists():
                    config_source = SourceExpr(LiteralExpr(f"$HOME/.vim/{vim_config}"))
                    configs.append(f"vim.cmd('{config_source.render()}')")
                if len(configs) > 0:
                    rendered_configs = "\n".join(configs)
                    prop.append(
                        LiteralExpr(
                            f"""config = function()
        {rendered_configs}
    end"""
                        )
                    )

                plugins.append(
                    Stmt(
                        IndentExpr(
                            CommaExpr(
                                LazySpecExpr4Lua(
                                    LiteralExpr(ctx.org),
                                    LiteralExpr(ctx.repo),
                                    Exprs(prop, ", ") if len(prop) > 0 else None,
                                )
                            )
                        )
                    )
                )
                # color settings
                if ctx.tag == Tag.COLORSCHEME:
                    colorschemes.append(
                        Stmt(
                            IndentExpr(
                                LineContinuationExpr(
                                    CommaExpr(SingleQuoteStringExpr(ctx.color))
                                )
                            )
                        )
                    )
        return plugins, colorschemes

    def assemble_props(self, ctx):
        if not ctx.prop:
            return []
        props = ctx.prop if isinstance(ctx.prop, list) else [ctx.prop]
        return [LiteralExpr(f"{p[0]} = {p[1]}") for p in props]

    def is_disabled(self, ctx):
        if self.no_plugs and str(ctx) in self.no_plugs:
            return True
        if self.no_color and ctx.tag == Tag.COLORSCHEME:
            return True
        if self.no_hilight and ctx.tag == Tag.HIGHLIGHT:
            return True
        if self.no_lang and ctx.tag == Tag.LANGUAGE:
            return True
        if self.no_edit and ctx.tag == Tag.EDITING:
            return True
        return False


class Dumper:
    def __init__(
        self,
        plugins,
        lspservers,
        colorschemes,
        settings,
        inits,
    ) -> None:
        self.plugins = plugins
        self.lspservers = lspservers
        self.colorschemes = colorschemes
        self.settings = settings
        self.inits = inits

    def dump(self):
        self.config()
        self.init_vim()

    def config(self):
        pathlib.Path(f"{VIM_DIR}/lua").mkdir(parents=True, exist_ok=True)

        plugins_lua = f"{VIM_DIR}/lua/plugins.lua"
        try_backup(pathlib.Path(plugins_lua))
        with open(plugins_lua, "w") as fp:
            fp.write(self.plugins)

        lspservers_lua = f"{VIM_DIR}/lua/lspservers.lua"
        try_backup(pathlib.Path(lspservers_lua))
        with open(lspservers_lua, "w") as fp:
            fp.write(self.lspservers)

        colorschemes_vim = f"{VIM_DIR}/colorschemes.vim"
        try_backup(pathlib.Path(colorschemes_vim))
        with open(colorschemes_vim, "w") as fp:
            fp.write(self.colorschemes)

        settings_vim = f"{VIM_DIR}/settings.vim"
        try_backup(pathlib.Path(settings_vim))
        with open(settings_vim, "w") as fp:
            fp.write(self.settings)

    def init_vim(self):
        if IS_WINDOWS:
            message(
                f"install {HOME_DIR}\\AppData\\Local\\nvim\\init.vim for neovim on windows"
            )
            appdata_local_dir = pathlib.Path(f"{HOME_DIR}/AppData/Local")
            nvim_dir = pathlib.Path(f"{appdata_local_dir}/nvim")
            init_vim = pathlib.Path(f"{appdata_local_dir}/nvim/init.vim")
        else:
            message("install ~/.config/nvim/init.vim for neovim")
            config_dir = pathlib.Path(f"{HOME_DIR}/.config")
            nvim_dir = pathlib.Path(f"{config_dir}/nvim")
            init_vim = pathlib.Path(f"{config_dir}/nvim/init.vim")
        try_backup(init_vim)
        try_backup(nvim_dir)
        nvim_dir.symlink_to(str(VIM_DIR), target_is_directory=True)
        try_backup(pathlib.Path(INIT_FILE))
        with open(INIT_FILE, "w") as fp:
            fp.write(self.inits)


class CommandHelp(click.Command):
    HELP_FILE = pathlib.Path(f"{VIM_DIR}/install/help.txt")

    def format_help(self, ctx, formatter):
        with open(CommandHelp.HELP_FILE, "r") as hf:
            formatter.write(hf.read())


@click.command(cls=CommandHelp)
@click.option("-b", "--basic", "basic_opt", is_flag=True, help="Basic mode")
@click.option("-l", "--limit", "limit_opt", is_flag=True, help="Limit mode")
@click.option(
    "--use-color",
    "use_color_opt",
    default=None,
    show_default=True,
    help="Use static colorscheme",
)
@click.option(
    "--no-color",
    "no_color_opt",
    is_flag=True,
    help="No extra colors",
)
@click.option(
    "--no-hilight",
    "no_hilight_opt",
    is_flag=True,
    help="No extra highlights",
)
@click.option(
    "--no-lang",
    "no_lang_opt",
    is_flag=True,
    help="No language supports",
)
@click.option(
    "--no-edit",
    "no_edit_opt",
    is_flag=True,
    help="No editing enhancements",
)
@click.option(
    "--no-plug",
    "no_plug_opt",
    multiple=True,
    help="No specific plugin",
)
@click.option(
    "--no-winctrl",
    "no_winctrl_opt",
    is_flag=True,
    help="No Windows ctrl+?(and cmd+? on macOS) keys",
)
def generator(
    basic_opt,
    limit_opt,
    use_color_opt,
    no_color_opt,
    no_hilight_opt,
    no_lang_opt,
    no_edit_opt,
    no_plug_opt,
    no_winctrl_opt,
):
    if limit_opt:
        no_color_opt = True
        no_hilight_opt = True
        no_lang_opt = True
        no_edit_opt = True
    render = Render(
        use_color_opt,
        no_color_opt,
        no_hilight_opt,
        no_lang_opt,
        no_edit_opt,
        no_plug_opt,
        no_winctrl_opt,
    )
    plugins, lspservers, colorschemes, settings, init = render.render()
    dumper = Dumper(plugins, lspservers, colorschemes, settings, init)
    dumper.dump()


if __name__ == "__main__":
    generator()
