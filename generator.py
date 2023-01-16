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
VIMRC_FILE = pathlib.Path(f"{VIM_DIR}/vimrc.vim")

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


class Indentable:
    def __init__(self):
        self._value = 0

    @property
    def indentlevel(self):
        return self._value

    def inc_indentlevel(self):
        self._value += 1

    def dec_indentlevel(self):
        self._value = max(self._value - 1, 0)

    def get_dec_indentlevel(self):
        return max(self._value - 1, 0)


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


class SourceVimDirStmt(Expr):
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
            return f"set guifont=Hack\\ NFM:h10"
        elif IS_MACOS:
            return f"set guifont=Hack\\ Nerd\\ Font\\ Mono:h13"
        else:
            # Linux
            return f"set guifont=Hack\\ Nerd\\ Font\\ Mono:h10"


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


class PluginTag(enum.Enum):
    COLORSCHEME = 1
    HIGHLIGHT = 2
    LANGUAGE = 3
    EDITING = 4
    INFRASTRUCTURE = 5


class PluginContext:
    def __init__(
        self,
        org,
        repo,
        post=None,
        color=None,
        top_clause=None,
        tag=None,
    ) -> None:
        self.org = org
        self.repo = repo
        self.post = post
        self.color = color
        self.top_clause = top_clause  # more clauses above this line
        self.tag = tag

    def __str__(self):
        return f"{self.org}/{self.repo}"


PLUGIN_CONTEXTS = [
    PluginContext(
        "wbthomason",
        "packer.nvim",
        top_clause=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Infrastructure ----")),
        ],
        tag=PluginTag.INFRASTRUCTURE,
    ),
    PluginContext(
        "nathom",
        "filetype.nvim",
        tag=PluginTag.INFRASTRUCTURE,
    ),
    PluginContext(
        "lewis6991",
        "impatient.nvim",
        tag=PluginTag.INFRASTRUCTURE,
    ),
    PluginContext(
        "neovim",
        "nvim-lspconfig",
        tag=PluginTag.INFRASTRUCTURE,
    ),
    PluginContext("nvim-lua", "plenary.nvim", tag=PluginTag.INFRASTRUCTURE),
    PluginContext(
        "lifepillar",
        "vim-solarized8",
        color="solarized8",
        top_clause=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Colorscheme ----")),
        ],
        tag=PluginTag.COLORSCHEME,
    ),
    PluginContext(
        "crusoexia", "vim-monokai", color="monokai", tag=PluginTag.COLORSCHEME
    ),
    PluginContext(
        "dracula",
        "vim",
        post="as = 'dracula'",
        color="dracula",
        tag=PluginTag.COLORSCHEME,
    ),
    PluginContext(
        "KeitaNakamura", "neodark.vim", color="neodark", tag=PluginTag.COLORSCHEME
    ),
    PluginContext(
        "srcery-colors", "srcery-vim", color="srcery", tag=PluginTag.COLORSCHEME
    ),
    PluginContext(
        "drewtempelmeyer", "palenight.vim", color="palenight", tag=PluginTag.COLORSCHEME
    ),
    PluginContext(
        "joshdick", "onedark.vim", color="onedark", tag=PluginTag.COLORSCHEME
    ),
    PluginContext("Rigellute", "rigel", color="rigel", tag=PluginTag.COLORSCHEME),
    PluginContext("sainnhe", "edge", color="edge", tag=PluginTag.COLORSCHEME),
    PluginContext(
        "sainnhe",
        "gruvbox-material",
        color="gruvbox-material",
        tag=PluginTag.COLORSCHEME,
    ),
    PluginContext(
        "sainnhe", "everforest", color="everforest", tag=PluginTag.COLORSCHEME
    ),
    PluginContext("sainnhe", "sonokai", color="sonokai", tag=PluginTag.COLORSCHEME),
    PluginContext(
        "kaicataldo",
        "material.vim",
        post="branch = 'main'",
        color="material",
        tag=PluginTag.COLORSCHEME,
    ),
    PluginContext(
        "projekt0n",
        "github-nvim-theme",
        color="github_dark",
        tag=PluginTag.COLORSCHEME,
    ),
    PluginContext(
        "folke",
        "tokyonight.nvim",
        post="branch = 'main'",
        color="tokyonight",
        tag=PluginTag.COLORSCHEME,
    ),
    PluginContext(
        "rebelot",
        "kanagawa.nvim",
        color="kanagawa",
        tag=PluginTag.COLORSCHEME,
    ),
    PluginContext(
        "EdenEast",
        "nightfox.nvim",
        color="nightfox",
        tag=PluginTag.COLORSCHEME,
    ),
    PluginContext(
        "RRethy",
        "vim-illuminate",
        top_clause=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Highlight ----")),
        ],
        tag=PluginTag.HIGHLIGHT,
    ),
    PluginContext(
        "NvChad",
        "nvim-colorizer.lua",
        tag=PluginTag.HIGHLIGHT,
    ),
    PluginContext(
        "andymass",
        "vim-matchup",
        tag=PluginTag.HIGHLIGHT,
    ),
    PluginContext(
        "inkarkat",
        "vim-mark",
        post="requires = 'inkarkat/vim-ingo-library'",
        tag=PluginTag.HIGHLIGHT,
    ),
    PluginContext(
        "romgrk",
        "barbar.nvim",
        post="requires = 'nvim-tree/nvim-web-devicons'",
        top_clause=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- UI ----")),
            CommentExpr(LiteralExpr("Tabline")),
        ],
    ),
    PluginContext(
        "kyazdani42",
        "nvim-tree.lua",
        post="requires = 'nvim-tree/nvim-web-devicons'",
        top_clause=CommentExpr(LiteralExpr("Explorer")),
    ),
    PluginContext("jlanzarotta", "bufexplorer"),
    PluginContext(
        "lukas-reineke",
        "indent-blankline.nvim",
        top_clause=CommentExpr(LiteralExpr("Indentline")),
        tag=PluginTag.HIGHLIGHT,
    ),
    PluginContext(
        "nvim-lualine",
        "lualine.nvim",
        post="requires = 'nvim-tree/nvim-web-devicons'",
        top_clause=CommentExpr(LiteralExpr("Statusline")),
    ),
    PluginContext("nvim-lua", "lsp-status.nvim"),
    PluginContext(
        "lewis6991",
        "gitsigns.nvim",
        top_clause=CommentExpr(LiteralExpr("Git")),
        tag=PluginTag.HIGHLIGHT,
    ),
    PluginContext(
        "akinsho",
        "toggleterm.nvim",
        post="tag = '*'",
        top_clause=CommentExpr(LiteralExpr("Terminal")),
        tag=PluginTag.HIGHLIGHT,
    ),
    PluginContext(
        "liuchengxu",
        "vista.vim",
        top_clause=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Tags ----")),
        ],
    ),
    PluginContext("ludovicchabant", "vim-gutentags"),
    PluginContext(
        "junegunn",
        "fzf",
        post='run = ":call fzf#install()"',
        top_clause=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Search ----")),
        ],
    ),
    PluginContext("junegunn", "fzf.vim"),
    PluginContext("ojroques", "nvim-lspfuzzy"),
    PluginContext(
        "williamboman",
        "mason.nvim",
        top_clause=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Language server ----")),
        ],
        tag=PluginTag.LANGUAGE,
    ),
    PluginContext(
        "williamboman",
        "mason-lspconfig.nvim",
        tag=PluginTag.LANGUAGE,
    ),
    PluginContext("jose-elias-alvarez", "null-ls.nvim", tag=PluginTag.LANGUAGE),
    PluginContext(
        "jay-babu",
        "mason-null-ls.nvim",
        tag=PluginTag.LANGUAGE,
    ),
    PluginContext(
        "hrsh7th",
        "cmp-nvim-lsp",
        tag=PluginTag.LANGUAGE,
    ),
    PluginContext(
        "hrsh7th",
        "cmp-buffer",
        tag=PluginTag.LANGUAGE,
    ),
    PluginContext(
        "hrsh7th",
        "cmp-path",
        tag=PluginTag.LANGUAGE,
    ),
    PluginContext(
        "hrsh7th",
        "cmp-cmdline",
        tag=PluginTag.LANGUAGE,
    ),
    PluginContext(
        "hrsh7th",
        "nvim-cmp",
        tag=PluginTag.LANGUAGE,
    ),
    PluginContext(
        "L3MON4D3",
        "LuaSnip",
        post="tag = 'v1.*'",
        tag=PluginTag.LANGUAGE,
    ),
    PluginContext(
        "saadparwaiz1",
        "cmp_luasnip",
        tag=PluginTag.LANGUAGE,
    ),
    PluginContext("rafamadriz", "friendly-snippets", tag=PluginTag.LANGUAGE),
    PluginContext(
        "iamcco",
        "markdown-preview.nvim",
        post=' run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" },',
        top_clause=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Language support ----")),
            CommentExpr(LiteralExpr("Markdown")),
        ],
        tag=PluginTag.LANGUAGE,
    ),
    PluginContext(
        "justinmk",
        "vim-syntax-extra",
        post="ft = {'lex', 'flex', 'yacc', 'bison'}",
        top_clause=CommentExpr(LiteralExpr("Lex/yacc, flex/bison")),
        tag=PluginTag.LANGUAGE,
    ),
    PluginContext(
        "rhysd",
        "vim-llvm",
        post="ft = {'llvm', 'mir', 'mlir', 'tablegen'}",
        top_clause=CommentExpr(LiteralExpr("LLVM")),
        tag=PluginTag.LANGUAGE,
    ),
    PluginContext(
        "uarun",
        "vim-protobuf",
        post="ft = {'proto'}",
        top_clause=CommentExpr(LiteralExpr("Protobuf")),
        tag=PluginTag.LANGUAGE,
    ),
    PluginContext(
        "zebradil",
        "hive.vim",
        post="ft = {'hive'}",
        top_clause=CommentExpr(LiteralExpr("Hive")),
        tag=PluginTag.LANGUAGE,
    ),
    PluginContext(
        "slim-template",
        "vim-slim",
        post="ft = {'slim'}",
        top_clause=CommentExpr(LiteralExpr("Slim")),
        tag=PluginTag.LANGUAGE,
    ),
    PluginContext(
        "alvan",
        "vim-closetag",
        top_clause=[
            EmptyStmt(),
            CommentExpr(LiteralExpr("---- Editing enhancement ----")),
            CommentExpr(LiteralExpr("HTML tag")),
        ],
        tag=PluginTag.EDITING,
    ),
    PluginContext(
        "numToStr",
        "Comment.nvim",
        top_clause=CommentExpr(LiteralExpr("Comment")),
        tag=PluginTag.EDITING,
    ),
    PluginContext(
        "phaazon",
        "hop.nvim",
        post="branch = 'v2'",
        top_clause=CommentExpr(LiteralExpr("Cursor motion")),
        tag=PluginTag.EDITING,
    ),
    PluginContext(
        "windwp",
        "nvim-autopairs",
        top_clause=CommentExpr(LiteralExpr("Autopair")),
        tag=PluginTag.EDITING,
    ),
    PluginContext(
        "haya14busa",
        "is.vim",
        top_clause=CommentExpr(LiteralExpr("Incremental search")),
        tag=PluginTag.EDITING,
    ),
    PluginContext(
        "tpope",
        "vim-repeat",
        tag=PluginTag.EDITING,
        top_clause=CommentExpr(LiteralExpr("Other")),
    ),
    PluginContext("chaoren", "vim-wordmotion", tag=PluginTag.EDITING),
    PluginContext("mattn", "emmet-vim", tag=PluginTag.EDITING),
    PluginContext("mbbill", "undotree", tag=PluginTag.EDITING),
    PluginContext("editorconfig", "editorconfig-vim", tag=PluginTag.EDITING),
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
        core_plugins, core_vimrcs, core_color_settings = self.render_core()

        plugin_stmts = self.render_plugin_stmts(core_plugins)
        lsp_setting_stmts = self.render_lsp_setting_stmts()
        color_setting_stmts = self.render_color_setting_stmts(core_color_settings)
        setting_stmts = self.render_setting_stmts()
        vimrc_stmts = self.render_vimrc_stmts(core_vimrcs)

        plugins_content = "".join([s.render() for s in plugin_stmts])
        lsp_settings_content = "".join([s.render() for s in lsp_setting_stmts])
        color_settings_content = "".join([s.render() for s in color_setting_stmts])
        settings_content = "".join([s.render() for s in setting_stmts])
        vimrc_content = "".join([s.render() for s in vimrc_stmts])
        return (
            plugins_content,
            lsp_settings_content,
            color_settings_content,
            settings_content,
            vimrc_content,
        )

    # plugins.vim
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

    # vimrc.vim
    def render_vimrc_stmts(self, core_vimrcs):
        vimrc_stmts = []
        vimrc_stmts.append(Stmt(CommentExpr(LiteralExpr("---- Vimrc ----"))))
        vimrc_stmts.append(Stmt(LuaExpr(LiteralExpr("require('plugins')"))))
        vimrc_stmts.append(SourceVimDirStmt("standalone/basic.vim"))
        vimrc_stmts.append(SourceVimDirStmt("standalone/filetype.vim"))

        # insert core vimrc statements
        vimrc_stmts.extend(core_vimrcs)

        vimrc_stmts.append(EmptyStmt())
        vimrc_stmts.append(Stmt(CommentExpr(LiteralExpr("---- Custom settings ----"))))
        vimrc_stmts.append(SourceVimDirStmt("lsp-settings.vim"))
        vimrc_stmts.append(SourceVimDirStmt("color-settings.vim"))
        vimrc_stmts.append(SourceVimDirStmt("settings.vim"))
        return vimrc_stmts

    # lsp-settings.vim
    def render_lsp_setting_stmts(self):
        lsp_setting_stmts = []
        lsp_setting_stmts.append(
            TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/lsp-settings-template.vim"))
        )
        return lsp_setting_stmts

    # color-settings.vim
    def render_color_setting_stmts(self, core_color_settings):
        color_setting_stmts = []
        color_setting_stmts.append(
            TemplateContent(
                pathlib.Path(f"{TEMPLATE_DIR}/color-settings-template-header.vim")
            )
        )
        color_setting_stmts.extend(core_color_settings)
        color_setting_stmts.append(
            TemplateContent(
                pathlib.Path(f"{TEMPLATE_DIR}/color-settings-template-footer.vim")
            )
        )
        return color_setting_stmts

    # settings.vim
    def render_setting_stmts(self):
        setting_stmts = []
        setting_stmts.extend(
            [
                EmptyStmt(),
                Stmt(CommentExpr(LiteralExpr("---- GUI Font ----"))),
                Stmt(HackNerdFontExpr()),
            ]
        )
        if self.static_color:
            setting_stmts.extend(
                [
                    EmptyStmt(),
                    Stmt(CommentExpr(LiteralExpr("---- Static colorscheme ----"))),
                    Stmt(ColorschemeExpr(LiteralExpr(self.static_color))),
                ]
            )
        elif not self.disable_color:
            setting_stmts.extend(
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
        setting_stmts.append(
            TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/settings-template.vim"))
        )
        return setting_stmts

    def render_core(self):
        plugin_stmts = []
        vimrc_stmts = []
        color_setting_stmts = []
        for ctx in PLUGIN_CONTEXTS:
            assert isinstance(ctx, PluginContext)
            # top
            if ctx.top_clause:
                tops = (
                    ctx.top_clause
                    if isinstance(ctx.top_clause, list)
                    else [ctx.top_clause]
                )
                for top in tops:
                    assert isinstance(top, Expr)
                    if isinstance(top, EmptyStmt):
                        plugin_stmts.append(to_lua(top))
                        vimrc_stmts.append(top)
                    elif isinstance(top, CommentExpr):
                        cs = Stmt(top)
                        plugin_stmts.append(Stmt(IndentExpr(to_lua(top))))
                        vimrc_stmts.append(cs)
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
                # vimrc
                lua_file = f"repository/{str(ctx).replace('.', '-')}"
                vim_file = f"repository/{ctx}.vim"
                if pathlib.Path(f"{HOME_DIR}/.vim/lua/{lua_file}.lua").exists():
                    vimrc_stmts.append(
                        Stmt(LuaExpr(LiteralExpr(f"require('{lua_file}')")))
                    )
                if pathlib.Path(f"{HOME_DIR}/.vim/{vim_file}").exists():
                    vimrc_stmts.append(SourceVimDirStmt(vim_file))
                # color settings
                if ctx.tag == PluginTag.COLORSCHEME:
                    color_setting_stmts.append(
                        Stmt(
                            IndentExpr(
                                LineContinuationExpr(
                                    CommaExpr(SingleQuoteStringExpr(ctx.color))
                                )
                            )
                        )
                    )
        return plugin_stmts, vimrc_stmts, color_setting_stmts

    def is_disabled(self, ctx):
        if self.disable_plugins and str(ctx) in self.disable_plugins:
            return True
        if self.disable_color and ctx.tag == PluginTag.COLORSCHEME:
            return True
        if self.disable_highlight and ctx.tag == PluginTag.HIGHLIGHT:
            return True
        if self.disable_language and ctx.tag == PluginTag.LANGUAGE:
            return True
        if self.disable_editing and ctx.tag == PluginTag.EDITING:
            return True
        return False


class FileDumper:
    def __init__(
        self,
        plugins_content,
        lsp_settings_content,
        color_settings_content,
        settings_content,
        vimrc_content,
    ) -> None:
        self.plugins_content = plugins_content
        self.lsp_settings_content = lsp_settings_content
        self.color_settings_content = color_settings_content
        self.settings_content = settings_content
        self.vimrc_content = vimrc_content

    def dump(self):
        self.config()
        self.neovim_init_vim_entry()

    def config(self):
        plugins_file = f"{VIM_DIR}/lua/plugins.lua"
        lsp_settings_file = f"{VIM_DIR}/lsp-settings.vim"
        color_settings_file = f"{VIM_DIR}/color-settings.vim"
        settings_file = f"{VIM_DIR}/settings.vim"
        try_backup(pathlib.Path(plugins_file))
        pathlib.Path(f"{VIM_DIR}/lua").mkdir(parents=True, exist_ok=True)
        with open(plugins_file, "w") as fp:
            fp.write(self.plugins_content)
        try_backup(pathlib.Path(lsp_settings_file))
        with open(lsp_settings_file, "w") as fp:
            fp.write(self.lsp_settings_content)
        try_backup(pathlib.Path(color_settings_file))
        with open(color_settings_file, "w") as fp:
            fp.write(self.color_settings_content)
        try_backup(pathlib.Path(settings_file))
        with open(settings_file, "w") as fp:
            fp.write(self.settings_content)
        try_backup(pathlib.Path(VIMRC_FILE))
        with open(VIMRC_FILE, "w") as fp:
            fp.write(self.vimrc_content)

    def neovim_init_vim_entry(self):
        if IS_WINDOWS:
            message(
                f"install {HOME_DIR}\\AppData\\Local\\nvim\\init.vim for neovim on windows"
            )
            appdata_local_path = pathlib.Path(f"{HOME_DIR}/AppData/Local")
            nvim_path = pathlib.Path(f"{appdata_local_path}/nvim")
            nvim_init_vim_path = pathlib.Path(f"{appdata_local_path}/nvim/init.vim")
        else:
            message("install ~/.config/nvim/init.vim for neovim")
            config_path = pathlib.Path(f"{HOME_DIR}/.config")
            nvim_path = pathlib.Path(f"{config_path}/nvim")
            nvim_init_vim_path = pathlib.Path(f"{config_path}/nvim/init.vim")
        try_backup(nvim_init_vim_path)
        try_backup(nvim_path)
        nvim_path.symlink_to(str(VIM_DIR), target_is_directory=True)
        nvim_init_vim_path.symlink_to(str(VIMRC_FILE))


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
        lsp_settings_content,
        color_settings_content,
        settings_content,
        vimrc_content,
    ) = render.render()
    dumper = FileDumper(
        plugins_content,
        lsp_settings_content,
        color_settings_content,
        settings_content,
        vimrc_content,
    )
    dumper.dump()


if __name__ == "__main__":
    generator()
