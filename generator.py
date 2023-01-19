#!/usr/bin/env python3

import abc
import datetime
import enum
import pathlib
import platform

import click

HOME_DIR = pathlib.Path.home()
VIM_DIR = pathlib.Path(f"{HOME_DIR}/.vim")
TEMPLATE_DIR = pathlib.Path(f"{HOME_DIR}/.vim/template")
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


class PlugExpr(Expr):
    def __init__(self, org, repo, post=None):
        assert isinstance(org, LiteralExpr)
        assert isinstance(repo, LiteralExpr)
        assert isinstance(post, LiteralExpr) or post is None
        self.org = org
        self.repo = repo
        self.post = post

    def render(self):
        return f"Plug '{self.org.render()}/{self.repo.render()}'{(', ' + self.post.render()) if self.post else ''}"


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


class PackerUseExpr4Lua(Expr):
    def __init__(self, org, repo, post=None):
        assert isinstance(org, LiteralExpr)
        assert isinstance(repo, LiteralExpr)
        assert isinstance(post, LiteralExpr) or post is None
        self.org = org
        self.repo = repo
        self.post = post

    def render(self):
        if self.post:
            return f"use {{ '{self.org.render()}/{self.repo.render()}', {self.post.render()} }}"
        else:
            return f"use {{ '{self.org.render()}/{self.repo.render()}' }}"


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
        post=None,
        above_clause=None,
        color=None,
        tag=None,
    ) -> None:
        self.org = org
        self.repo = repo
        self.post = post
        self.above_clause = above_clause  # more clauses above this line
        self.color = color
        self.tag = tag

    def __str__(self):
        return f"{self.org}/{self.repo}"


PLUGINS = [
    # Infrastructure
    Plugin(
        "wbthomason",
        "packer.nvim",
        above_clause=[
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
        "lewis6991",
        "impatient.nvim",
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
        above_clause=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Colorscheme ----")),
        ],
        color="nightfly",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "bluz71",
        "vim-moonfly-colors",
        color="moonfly",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "catppuccin",
        "nvim",
        post="as = 'catppuccin'",
        color="catppuccin",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "challenger-deep-theme",
        "vim",
        post="as = 'challenger-deep'",
        color="challenger_deep",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "cocopon",
        "iceberg.vim",
        color="iceberg",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "EdenEast",
        "nightfox.nvim",
        color="nightfox",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "embark-theme",
        "vim",
        post="as = 'embark'",
        color="embark",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "fenetikm",
        "falcon",
        color="falcon",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "folke",
        "tokyonight.nvim",
        post="branch = 'main'",
        color="tokyonight",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "ishan9299",
        "nvim-solarized-lua",
        above_clause=CommentExpr(LiteralExpr("inherit 'lifepillar/vim-solarized8'")),
        color="solarized",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "junegunn",
        "seoul256.vim",
        color="seoul256",
        tag=Tag.COLORSCHEME,
    ),
    Plugin("KeitaNakamura", "neodark.vim", color="neodark", tag=Tag.COLORSCHEME),
    Plugin(
        "luisiacc",
        "gruvbox-baby",
        above_clause=CommentExpr(LiteralExpr("inherit sainnhe/gruvbox-material")),
        post="branch = 'main'",
        color="gruvbox-baby",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "marko-cerovac",
        "material.nvim",
        above_clause=CommentExpr(LiteralExpr("inherit kaicataldo/material.vim")),
        color="material",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "mhartington",
        "oceanic-next",
        color="OceanicNext",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "Mofiqul",
        "dracula.nvim",
        above_clause=CommentExpr(LiteralExpr("inherit dracula/vim")),
        color="dracula",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "navarasu",
        "onedark.nvim",
        above_clause=CommentExpr(LiteralExpr("inherit joshdick/onedark.vim")),
        color="onedark",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "NLKNguyen",
        "papercolor-theme",
        color="PaperColor",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "olimorris",
        "onedarkpro.nvim",
        above_clause=CommentExpr(LiteralExpr("inherit tomasiser/vim-code-dark")),
        color="onedark",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "pineapplegiant",
        "spaceduck",
        color="spaceduck",
        post="branch = 'main'",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "preservim",
        "vim-colors-pencil",
        color="pencil",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "projekt0n",
        "github-nvim-theme",
        color="github_dark",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "raphamorim",
        "lucario",
        color="lucario",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "rebelot",
        "kanagawa.nvim",
        color="kanagawa",
        tag=Tag.COLORSCHEME,
    ),
    Plugin("Rigellute", "rigel", color="rigel", tag=Tag.COLORSCHEME),
    Plugin(
        "romainl",
        "Apprentice",
        color="apprentice",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "rose-pine",
        "neovim",
        color="rose-pine",
        post="as = 'rose-pine'",
        tag=Tag.COLORSCHEME,
    ),
    Plugin("sainnhe", "edge", color="edge", tag=Tag.COLORSCHEME),
    Plugin("sainnhe", "everforest", color="everforest", tag=Tag.COLORSCHEME),
    Plugin(
        "sainnhe",
        "sonokai",
        above_clause=CommentExpr(LiteralExpr("inherit sickill/vim-monokai")),
        color="sonokai",
        tag=Tag.COLORSCHEME,
    ),
    Plugin("shaunsingh", "nord.nvim", color="nord", tag=Tag.COLORSCHEME),
    Plugin("sonph", "onehalf", 
           post="rtp = 'vim/'",
           color="onehalfdark", tag=Tag.COLORSCHEME),
    Plugin("srcery-colors", "srcery-vim", color="srcery", tag=Tag.COLORSCHEME),
    # Highlight
    Plugin(
        "RRethy",
        "vim-illuminate",
        above_clause=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Highlight ----")),
        ],
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        "NvChad",
        "nvim-colorizer.lua",
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        "andymass",
        "vim-matchup",
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        "inkarkat",
        "vim-mark",
        post="requires = 'inkarkat/vim-ingo-library'",
        tag=Tag.HIGHLIGHT,
    ),
    # UI
    Plugin(
        "romgrk",
        "barbar.nvim",
        post="requires = 'nvim-tree/nvim-web-devicons'",
        above_clause=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- UI ----")),
            CommentExpr(LiteralExpr("Tabline")),
        ],
    ),
    Plugin(
        "nvim-tree",
        "nvim-tree.lua",
        post="requires = 'nvim-tree/nvim-web-devicons'",
        above_clause=CommentExpr(LiteralExpr("Explorer")),
    ),
    Plugin("jlanzarotta", "bufexplorer"),
    Plugin(
        "lukas-reineke",
        "indent-blankline.nvim",
        above_clause=CommentExpr(LiteralExpr("Indentline")),
    ),
    Plugin(
        "nvim-lualine",
        "lualine.nvim",
        post="requires = 'nvim-tree/nvim-web-devicons'",
        above_clause=CommentExpr(LiteralExpr("Statusline")),
    ),
    Plugin("nvim-lua", "lsp-status.nvim"),
    Plugin(
        "lewis6991",
        "gitsigns.nvim",
        above_clause=CommentExpr(LiteralExpr("Git")),
    ),
    Plugin(
        "akinsho",
        "toggleterm.nvim",
        post="tag = '*'",
        above_clause=CommentExpr(LiteralExpr("Terminal")),
    ),
    Plugin(
        "stevearc",
        "dressing.nvim",
        above_clause=CommentExpr(LiteralExpr("UI hooks")),
    ),
    Plugin(
        "karb94",
        "neoscroll.nvim",
        above_clause=CommentExpr(LiteralExpr("Smooth scrolling")),
    ),
    Plugin(
        "liuchengxu",
        "vista.vim",
        above_clause=CommentExpr(LiteralExpr("Structures/Outlines")),
    ),
    Plugin("ludovicchabant", "vim-gutentags"),
    # Search
    Plugin(
        "junegunn",
        "fzf",
        post='run = ":call fzf#install()"',
        above_clause=[
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
        above_clause=[
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
        post="requires = 'nvim-lua/plenary.nvim'",
        tag=Tag.LANGUAGE,
    ),
    Plugin("jay-babu", "mason-null-ls.nvim", tag=Tag.LANGUAGE),
    Plugin(
        "hrsh7th",
        "cmp-nvim-lsp",
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "hrsh7th",
        "cmp-buffer",
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "hrsh7th",
        "cmp-path",
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "hrsh7th",
        "cmp-cmdline",
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "hrsh7th",
        "nvim-cmp",
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "L3MON4D3",
        "LuaSnip",
        post="tag = 'v1.*'",
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "saadparwaiz1",
        "cmp_luasnip",
        tag=Tag.LANGUAGE,
    ),
    Plugin("rafamadriz", "friendly-snippets", tag=Tag.LANGUAGE),
    # Language support
    Plugin(
        "iamcco",
        "markdown-preview.nvim",
        post=' run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" },',
        above_clause=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Language support ----")),
            CommentExpr(LiteralExpr("Markdown")),
        ],
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "p00f",
        "clangd_extensions.nvim",
        above_clause=CommentExpr(LiteralExpr("Clangd extension")),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "simrat39",
        "rust-tools.nvim",
        above_clause=CommentExpr(LiteralExpr("Rust-analyzer extension")),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "justinmk",
        "vim-syntax-extra",
        post="ft = {'lex', 'flex', 'yacc', 'bison'}",
        above_clause=CommentExpr(LiteralExpr("Lex/yacc, flex/bison")),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "rhysd",
        "vim-llvm",
        post="ft = {'llvm', 'mir', 'mlir', 'tablegen'}",
        above_clause=CommentExpr(LiteralExpr("LLVM")),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "zebradil",
        "hive.vim",
        post="ft = {'hive'}",
        above_clause=CommentExpr(LiteralExpr("Hive")),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "slim-template",
        "vim-slim",
        post="ft = {'slim'}",
        above_clause=CommentExpr(LiteralExpr("Slim")),
        tag=Tag.LANGUAGE,
    ),
    # Movement
    Plugin(
        "phaazon",
        "hop.nvim",
        post="branch = 'v2'",
        above_clause=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Movement ----")),
            CommentExpr(LiteralExpr("Cursor Movement")),
        ],
        tag=Tag.EDITING,
    ),
    Plugin(
        "ggandor", "leap.nvim", post="requires = 'tpope/vim-repeat'", tag=Tag.EDITING
    ),
    Plugin("chaoren", "vim-wordmotion", tag=Tag.EDITING),
    # Editing enhancement
    Plugin(
        "alvan",
        "vim-closetag",
        above_clause=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Editing enhancement ----")),
            CommentExpr(LiteralExpr("HTML tag")),
        ],
        tag=Tag.EDITING,
    ),
    Plugin(
        "numToStr",
        "Comment.nvim",
        above_clause=CommentExpr(LiteralExpr("Comment")),
        tag=Tag.EDITING,
    ),
    Plugin(
        "windwp",
        "nvim-autopairs",
        above_clause=CommentExpr(LiteralExpr("Autopair")),
        tag=Tag.EDITING,
    ),
    Plugin(
        "haya14busa",
        "is.vim",
        above_clause=CommentExpr(LiteralExpr("Incremental search")),
        tag=Tag.EDITING,
    ),
    Plugin(
        "tpope",
        "vim-repeat",
        above_clause=CommentExpr(LiteralExpr("Other")),
        tag=Tag.EDITING,
    ),
    Plugin("mbbill", "undotree", tag=Tag.EDITING),
    Plugin("editorconfig", "editorconfig-vim", tag=Tag.EDITING),
]


class Render:
    def __init__(
        self,
        static_color=None,
        disable_color=False,
        disable_highlight=False,
        disable_language=False,
        disable_editing=False,
        disable_plugins=None,
    ):
        self.static_color = static_color
        self.disable_color = disable_color
        self.disable_highlight = disable_highlight
        self.disable_language = disable_language
        self.disable_editing = disable_editing
        self.disable_plugins = disable_plugins

    def render(self):
        generated_plugins, generated_inits, generated_colorschemes = self.generate()

        plugin_stmts = self.render_plugin_stmts(generated_plugins)
        lspserver_stmts = self.render_lspserver_stmts()
        colorscheme_stmts = self.render_colorscheme_stmts(generated_colorschemes)
        setting_stmts = self.render_setting_stmts()
        init_stmts = self.render_init_stmts(generated_inits)

        plugins_content = "".join([s.render() for s in plugin_stmts])
        lspservers_content = "".join([s.render() for s in lspserver_stmts])
        colorschemes_content = "".join([s.render() for s in colorscheme_stmts])
        settings_content = "".join([s.render() for s in setting_stmts])
        init_content = "".join([s.render() for s in init_stmts])
        return (
            plugins_content,
            lspservers_content,
            colorschemes_content,
            settings_content,
            init_content,
        )

    # plugins.lua
    def render_plugin_stmts(self, core_plugins):
        plugin_stmts = []
        plugin_stmts.append(
            TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/plugins-template-header.lua"))
        )
        plugin_stmts.extend(core_plugins)
        plugin_stmts.append(
            TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/plugins-template-footer.lua"))
        )
        return plugin_stmts

    # init.vim
    def render_init_stmts(self, core_inits):
        init_stmts = []
        init_stmts.append(Stmt(CommentExpr(LiteralExpr("---- Init ----"))))
        init_stmts.append(LuaRequireStmt("plugins"))
        init_stmts.append(SourceStmtFromVimHome("config/basic.vim"))
        init_stmts.append(SourceStmtFromVimHome("config/filetype.vim"))
        init_stmts.append(LuaRequireStmt("constants"))

        # insert core init statements
        init_stmts.extend(core_inits)

        init_stmts.append(EmptyStmt())
        init_stmts.append(Stmt(CommentExpr(LiteralExpr("---- Generated ----"))))
        init_stmts.append(LuaRequireStmt("lspservers"))
        init_stmts.append(SourceStmtFromVimHome("colorschemes.vim"))
        init_stmts.append(SourceStmtFromVimHome("settings.vim"))
        return init_stmts

    # lspservers.lua
    def render_lspserver_stmts(self):
        lsp_setting_stmts = []
        if not self.disable_language:
            lsp_setting_stmts.append(
                TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/lspservers-template.lua"))
            )
        return lsp_setting_stmts

    # colorschemes.vim
    def render_colorscheme_stmts(self, core_color_settings):
        color_setting_stmts = []
        color_setting_stmts.append(
            TemplateContent(
                pathlib.Path(f"{TEMPLATE_DIR}/colorschemes-template-header.vim")
            )
        )
        color_setting_stmts.extend(core_color_settings)
        color_setting_stmts.append(
            TemplateContent(
                pathlib.Path(f"{TEMPLATE_DIR}/colorschemes-template-footer.vim")
            )
        )
        return color_setting_stmts

    # settings.vim
    def render_setting_stmts(self):
        other_setting_stmts = []
        other_setting_stmts.extend(
            [
                EmptyStmt(),
                Stmt(CommentExpr(LiteralExpr("---- GUI Font ----"))),
                Stmt(HackNerdFontExpr()),
            ]
        )
        if self.static_color:
            other_setting_stmts.extend(
                [
                    EmptyStmt(),
                    Stmt(CommentExpr(LiteralExpr("---- Static colorscheme ----"))),
                    Stmt(ColorschemeExpr(LiteralExpr(self.static_color))),
                ]
            )
        elif not self.disable_color:
            other_setting_stmts.extend(
                [
                    EmptyStmt(),
                    Stmt(
                        CommentExpr(
                            LiteralExpr("---- Random colorscheme on startup ----")
                        )
                    ),
                    Stmt(
                        CallExpr(
                            FunctionInvokeExpr(LiteralExpr("LinNextRandomColorScheme"))
                        )
                    ),
                ]
            )
        other_setting_stmts.append(
            TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/settings-template.vim"))
        )
        return other_setting_stmts

    def generate(self):
        plugin_stmts = []
        init_stmts = []
        colorscheme_stmts = []
        for ctx in PLUGINS:
            assert isinstance(ctx, Plugin)
            # above
            if ctx.above_clause:
                aboves = (
                    ctx.above_clause
                    if isinstance(ctx.above_clause, list)
                    else [ctx.above_clause]
                )
                for above in aboves:
                    assert isinstance(above, Expr)
                    if isinstance(above, EmptyStmt):
                        plugin_stmts.append(to_lua(above))
                        init_stmts.append(above)
                    elif isinstance(above, CommentExpr):
                        cs = Stmt(above)
                        plugin_stmts.append(Stmt(IndentExpr(to_lua(above))))
                        init_stmts.append(cs)
                    else:
                        assert False
            # body
            if not self.is_disabled(ctx):
                # plugins
                plugin_stmts.append(
                    Stmt(
                        IndentExpr(
                            PackerUseExpr4Lua(
                                LiteralExpr(ctx.org),
                                LiteralExpr(ctx.repo),
                                LiteralExpr(ctx.post) if ctx.post else None,
                            )
                        )
                    )
                )
                # init
                lua_file = f"repository/{str(ctx).replace('.', '-')}"
                vim_file = f"repository/{ctx}.vim"
                if pathlib.Path(f"{HOME_DIR}/.vim/lua/{lua_file}.lua").exists():
                    init_stmts.append(LuaRequireStmt(lua_file))
                if pathlib.Path(f"{HOME_DIR}/.vim/{vim_file}").exists():
                    init_stmts.append(SourceStmtFromVimHome(vim_file))
                # color settings
                if ctx.tag == Tag.COLORSCHEME:
                    colorscheme_stmts.append(
                        Stmt(
                            IndentExpr(
                                LineContinuationExpr(
                                    CommaExpr(SingleQuoteStringExpr(ctx.color))
                                )
                            )
                        )
                    )
        return plugin_stmts, init_stmts, colorscheme_stmts

    def is_disabled(self, ctx):
        if self.disable_plugins and str(ctx) in self.disable_plugins:
            return True
        if self.disable_color and ctx.tag == Tag.COLORSCHEME:
            return True
        if self.disable_highlight and ctx.tag == Tag.HIGHLIGHT:
            return True
        if self.disable_language and ctx.tag == Tag.LANGUAGE:
            return True
        if self.disable_editing and ctx.tag == Tag.EDITING:
            return True
        return False


class FileDumper:
    def __init__(
        self,
        plugins_content,
        lspservers_content,
        colorschemes_content,
        settings_content,
        init_content,
    ) -> None:
        self.plugins_content = plugins_content
        self.lspservers_content = lspservers_content
        self.colorschemes_content = colorschemes_content
        self.settings_content = settings_content
        self.init_content = init_content

    def dump(self):
        self.config()
        self.init_vim()

    def config(self):
        pathlib.Path(f"{VIM_DIR}/lua").mkdir(parents=True, exist_ok=True)

        plugins_file = f"{VIM_DIR}/lua/plugins.lua"
        try_backup(pathlib.Path(plugins_file))
        with open(plugins_file, "w") as fp:
            fp.write(self.plugins_content)

        lspservers_file = f"{VIM_DIR}/lua/lspservers.lua"
        try_backup(pathlib.Path(lspservers_file))
        with open(lspservers_file, "w") as fp:
            fp.write(self.lspservers_content)

        colorschemes_file = f"{VIM_DIR}/colorschemes.vim"
        try_backup(pathlib.Path(colorschemes_file))
        with open(colorschemes_file, "w") as fp:
            fp.write(self.colorschemes_content)

        settings_file = f"{VIM_DIR}/settings.vim"
        try_backup(pathlib.Path(settings_file))
        with open(settings_file, "w") as fp:
            fp.write(self.settings_content)

    def init_vim(self):
        if IS_WINDOWS:
            message(
                f"install {HOME_DIR}\\AppData\\Local\\nvim\\init.vim for neovim on windows"
            )
            appdata_local_path = pathlib.Path(f"{HOME_DIR}/AppData/Local")
            nvim_path = pathlib.Path(f"{appdata_local_path}/nvim")
            init_path = pathlib.Path(f"{appdata_local_path}/nvim/init.vim")
        else:
            message("install ~/.config/nvim/init.vim for neovim")
            config_path = pathlib.Path(f"{HOME_DIR}/.config")
            nvim_path = pathlib.Path(f"{config_path}/nvim")
            init_path = pathlib.Path(f"{config_path}/nvim/init.vim")
        try_backup(init_path)
        try_backup(nvim_path)
        nvim_path.symlink_to(str(VIM_DIR), target_is_directory=True)
        try_backup(pathlib.Path(INIT_FILE))
        with open(INIT_FILE, "w") as fp:
            fp.write(self.init_content)


class CommandHelp(click.Command):
    HELP_FILE = pathlib.Path(f"{VIM_DIR}/install/help.txt")

    def format_help(self, ctx, formatter):
        with open(CommandHelp.HELP_FILE, "r") as hf:
            formatter.write(hf.read())


@click.command(cls=CommandHelp)
@click.option("-b", "--basic", "basic_opt", is_flag=True, help="Basic mode")
@click.option("-l", "--limit", "limit_opt", is_flag=True, help="Limit mode")
@click.option(
    "--static-color",
    "static_color_opt",
    default=None,
    show_default=True,
    help="Use static colorscheme",
)
@click.option(
    "--disable-color",
    "disable_color_opt",
    is_flag=True,
    help="Disable extra colors",
)
@click.option(
    "--disable-highlight",
    "disable_highlight_opt",
    is_flag=True,
    help="Disable extra highlights",
)
@click.option(
    "--disable-language",
    "disable_language_opt",
    is_flag=True,
    help="Disable language support",
)
@click.option(
    "--disable-editing",
    "disable_editing_opt",
    is_flag=True,
    help="Disable editing enhancement",
)
@click.option(
    "--disable-plugin",
    "disable_plugin_opt",
    multiple=True,
    help="Disable specific vim plugin",
)
def generator(
    basic_opt,
    limit_opt,
    static_color_opt,
    disable_color_opt,
    disable_highlight_opt,
    disable_language_opt,
    disable_editing_opt,
    disable_plugin_opt,
):
    if limit_opt:
        disable_color_opt = True
        disable_highlight_opt = True
        disable_language_opt = True
        disable_editing_opt = True
    render = Render(
        static_color_opt,
        disable_color_opt,
        disable_highlight_opt,
        disable_language_opt,
        disable_editing_opt,
        disable_plugin_opt,
    )
    (
        plugins_content,
        lspservers_content,
        colorschemes_content,
        settings_content,
        init_content,
    ) = render.render()
    dumper = FileDumper(
        plugins_content,
        lspservers_content,
        colorschemes_content,
        settings_content,
        init_content,
    )
    dumper.dump()


if __name__ == "__main__":
    generator()
