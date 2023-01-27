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
        self.exprs = [e for e in exprs if e is not None]
        self.delimiter = delimiter

    def render(self):
        return self.delimiter.join([e.render() for e in self.exprs])


class AssignExpr(Expr):
    def __init__(self, lhs, rhs) -> None:
        assert isinstance(lhs, Expr)
        assert isinstance(rhs, Expr)
        self.lhs = lhs
        self.rhs = rhs

    def render(self):
        return f"{self.lhs.render()} = {self.rhs.render()}"


# }

# Lua AST {


class CommentExpr4Lua(Expr):
    def __init__(self, expr):
        assert isinstance(expr, Expr)
        self.expr = expr

    def render(self):
        return f"-- {self.expr.render()}"


class LazySpecExpr4Lua(Expr):
    def __init__(self, repo, prop=None):
        assert isinstance(repo, Expr)
        assert isinstance(prop, Expr) or prop is None
        self.repo = repo
        self.prop = prop

    def render(self):
        if not self.prop:
            return f"'{self.repo.render()}'"
        else:
            return f"""{{ '{self.repo.render()}', {self.prop.render()} }}"""


class BracedExpr4Lua(Expr):
    def __init__(self, expr, count=1):
        assert isinstance(expr, Expr)
        assert isinstance(count, int)
        assert count >= 1
        self.expr = expr
        self.count = count

    def render(self):
        left_braces = "{" * self.count
        right_braces = "}" * self.count
        return f"{left_braces} {self.expr.render()} {right_braces}"


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
        repo,
        prop=None,
        above=None,
        color=None,
        tag=None,
    ) -> None:
        self.repo = repo  # https://github.com/{repo}
        self.prop = prop  # more plugin properties following this line
        self.above = above  # more clauses above this line
        self.color = color
        self.tag = tag

    def __str__(self):
        return self.repo.render() if isinstance(self.repo, Expr) else str(self.repo)


# Helper Expr {


class BigComment(Expr):
    def __init__(self, *value):
        assert value is not None
        stmts = []
        stmts.append(EmptyStmt())
        stmts.extend(
            [IndentExpr(CommentExpr4Lua(LiteralExpr(f"---- {v} ----"))) for v in value]
        )
        self.expr = Exprs(stmts, delimiter="\n")

    def render(self):
        return self.expr.render()


class SmallComment(Expr):
    def __init__(self, *value):
        assert value is not None
        stmts = [IndentExpr(CommentExpr4Lua(LiteralExpr(v))) for v in value]
        self.expr = Exprs(stmts, delimiter="\n")

    def render(self):
        return self.expr.render()


class LazyProp(Expr):
    def __init__(self, value="true"):
        assert value == "true" or value == "false"
        self.expr = AssignExpr(LiteralExpr("lazy"), LiteralExpr(value))

    def render(self):
        return self.expr.render()


class NameProp(Expr):
    def __init__(self, value):
        assert isinstance(value, str)
        self.expr = AssignExpr(LiteralExpr("name"), SingleQuoteStringExpr(value))

    def render(self):
        return self.expr.render()


class BranchProp(Expr):
    def __init__(self, value):
        assert isinstance(value, str)
        self.expr = AssignExpr(LiteralExpr("branch"), SingleQuoteStringExpr(value))

    def render(self):
        return self.expr.render()


class EventProp(Expr):
    def __init__(self, *value) -> None:
        self.expr = AssignExpr(
            LiteralExpr("event"),
            BracedExpr4Lua(
                Exprs([SingleQuoteStringExpr(v) for v in value], delimiter=", ")
            ),
        )

    def render(self):
        return self.expr.render()


class DependenciesProp(Expr):
    def __init__(self, *value):
        self.expr = AssignExpr(
            LiteralExpr("dependencies"),
            BracedExpr4Lua(
                Exprs([SingleQuoteStringExpr(v) for v in value], delimiter=", ")
            ),
        )

    def render(self):
        return self.expr.render()


class VersionProp(Expr):
    def __init__(self, value) -> None:
        assert isinstance(value, str)
        self.expr = AssignExpr(LiteralExpr("version"), SingleQuoteStringExpr(value))

    def render(self):
        return self.expr.render()


class BuildProp(Expr):
    def __init__(self, value) -> None:
        assert isinstance(value, str)
        self.expr = AssignExpr(LiteralExpr("build"), SingleQuoteStringExpr(value))

    def render(self):
        return self.expr.render()


class FtProp(Expr):
    def __init__(self, *value) -> None:
        self.expr = AssignExpr(
            LiteralExpr("ft"),
            BracedExpr4Lua(
                Exprs([SingleQuoteStringExpr(v) for v in value], delimiter=", ")
            ),
        )

    def render(self):
        return self.expr.render()


# }

PLUGINS = [
    # Infrastructure
    Plugin(
        LiteralExpr("nathom/filetype.nvim"),
        tag=Tag.INFRASTRUCTURE,
    ),
    Plugin(
        LiteralExpr("neovim/nvim-lspconfig"),
        tag=Tag.INFRASTRUCTURE,
    ),
    # Colorscheme
    Plugin(
        LiteralExpr("bluz71/vim-nightfly-colors"),
        prop=LazyProp(),
        above=BigComment("Colorscheme"),
        color="nightfly",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("bluz71/vim-moonfly-colors"),
        prop=LazyProp(),
        color="moonfly",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("catppuccin/nvim"),
        prop=Exprs(
            [
                NameProp("catppuccin"),
                LazyProp(),
            ],
            delimiter=", ",
        ),
        color="catppuccin",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("challenger-deep-theme/vim"),
        prop=Exprs(
            [
                NameProp("challenger-deep"),
                LazyProp(),
            ],
            delimiter=", ",
        ),
        color="challenger_deep",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("cocopon/iceberg.vim"),
        prop=LazyProp(),
        color="iceberg",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("EdenEast/nightfox.nvim"),
        prop=LazyProp(),
        color="nightfox",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("embark-theme/vim"),
        prop=Exprs(
            [
                NameProp("embark"),
                LazyProp(),
            ],
            delimiter=", ",
        ),
        color="embark",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("fenetikm/falcon"),
        prop=LazyProp(),
        color="falcon",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("folke/tokyonight.nvim"),
        prop=Exprs(
            [
                BranchProp("main"),
                LazyProp(),
            ],
            delimiter=", ",
        ),
        color="tokyonight",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("ishan9299/nvim-solarized-lua"),
        prop=LazyProp(),
        above=SmallComment("inherit 'lifepillar/vim-solarized8'"),
        color="solarized",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("junegunn/seoul256.vim"),
        prop=LazyProp(),
        color="seoul256",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("luisiacc/gruvbox-baby"),
        prop=Exprs(
            [
                BranchProp("main"),
                LazyProp(),
            ],
            delimiter=", ",
        ),
        above=SmallComment("inherit sainnhe/gruvbox-material"),
        color="gruvbox-baby",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("marko-cerovac/material.nvim"),
        prop=LazyProp(),
        above=SmallComment("inherit kaicataldo/material.vim"),
        color="material",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("mhartington/oceanic-next"),
        prop=LazyProp(),
        color="OceanicNext",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("Mofiqul/dracula.nvim"),
        prop=LazyProp(),
        above=SmallComment("inherit dracula/vim"),
        color="dracula",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("navarasu/onedark.nvim"),
        prop=LazyProp(),
        above=SmallComment(
            "inherit joshdick/onedark.vim, tomasiser/vim-code-dark, olimorris/onedarkpro.nvim"
        ),
        color="onedark",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("NLKNguyen/papercolor-theme"),
        prop=LazyProp(),
        color="PaperColor",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("pineapplegiant/spaceduck"),
        color="spaceduck",
        prop=Exprs(
            [
                BranchProp("main"),
                LazyProp(),
            ],
            delimiter=", ",
        ),
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("preservim/vim-colors-pencil"),
        prop=LazyProp(),
        color="pencil",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("projekt0n/github-nvim-theme"),
        prop=LazyProp(),
        color="github_dark",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("raphamorim/lucario"),
        prop=LazyProp(),
        color="lucario",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("rebelot/kanagawa.nvim"),
        prop=LazyProp(),
        color="kanagawa",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("Rigellute/rigel"),
        prop=LazyProp(),
        color="rigel",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("romainl/Apprentice"),
        prop=LazyProp(),
        color="apprentice",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("rose-pine/neovim"),
        color="rose-pine",
        prop=Exprs(
            [
                NameProp("rose-pine"),
                LazyProp(),
            ],
            delimiter=", ",
        ),
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("sainnhe/edge"),
        prop=LazyProp(),
        color="edge",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("sainnhe/everforest"),
        prop=LazyProp(),
        color="everforest",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("sainnhe/sonokai"),
        prop=LazyProp(),
        above=SmallComment("inherit sickill/vim-monokai"),
        color="sonokai",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("shaunsingh/nord.nvim"),
        prop=LazyProp(),
        color="nord",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("srcery-colors/srcery-vim"),
        prop=LazyProp(),
        color="srcery",
        tag=Tag.COLORSCHEME,
    ),
    # Highlight
    Plugin(
        LiteralExpr("RRethy/vim-illuminate"),
        above=BigComment("Highlight"),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        LiteralExpr("NvChad/nvim-colorizer.lua"),
        prop=EventProp("VeryLazy"),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        LiteralExpr("andymass/vim-matchup"),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        LiteralExpr("inkarkat/vim-mark"),
        prop=Exprs(
            [
                DependenciesProp("inkarkat/vim-ingo-library"),
                EventProp("VeryLazy"),
            ],
            delimiter=", ",
        ),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        LiteralExpr("nvim-tree/nvim-tree.lua"),
        prop=DependenciesProp("nvim-tree/nvim-web-devicons"),
        above=Exprs([BigComment("UI"), SmallComment("File explorer")], delimiter="\n"),
    ),
    Plugin(
        LiteralExpr("akinsho/bufferline.nvim"),
        prop=Exprs(
            [
                VersionProp("v3.*"),
                DependenciesProp(
                    "nvim-tree/nvim-web-devicons",
                    "famiu/bufdelete.nvim",
                ),
            ],
            delimiter=", ",
        ),
        above=SmallComment("Tabline"),
    ),
    Plugin(
        LiteralExpr("lukas-reineke/indent-blankline.nvim"),
        above=SmallComment("Indentline"),
    ),
    Plugin(
        LiteralExpr("nvim-lualine/lualine.nvim"),
        prop=DependenciesProp("nvim-tree/nvim-web-devicons"),
        above=SmallComment("Statusline"),
    ),
    Plugin(LiteralExpr("nvim-lua/lsp-status.nvim")),
    Plugin(
        LiteralExpr("lewis6991/gitsigns.nvim"),
        above=SmallComment("Git"),
    ),
    Plugin(
        LiteralExpr("akinsho/toggleterm.nvim"),
        prop=Exprs(
            [
                VersionProp("*"),
                EventProp("VeryLazy"),
            ],
            delimiter=", ",
        ),
        above=SmallComment("Terminal"),
    ),
    Plugin(
        LiteralExpr("stevearc/dressing.nvim"),
        above=SmallComment("UI hooks"),
    ),
    Plugin(
        LiteralExpr("liuchengxu/vista.vim"),
        prop=EventProp("VeryLazy"),
        above=SmallComment("Structures/Outlines"),
    ),
    Plugin(LiteralExpr("ludovicchabant/vim-gutentags")),
    # Search
    Plugin(
        LiteralExpr("junegunn/fzf"),
        prop=BuildProp(":call fzf#install()"),
        above=BigComment("Search"),
    ),
    Plugin(LiteralExpr("junegunn/fzf.vim")),
    Plugin(LiteralExpr("ojroques/nvim-lspfuzzy")),
    # LSP server
    Plugin(
        LiteralExpr("williamboman/mason.nvim"),
        above=BigComment("LSP server"),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("williamboman/mason-lspconfig.nvim"),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("jose-elias-alvarez/null-ls.nvim"),
        prop=DependenciesProp("nvim-lua/plenary.nvim"),
        tag=Tag.LANGUAGE,
    ),
    Plugin(LiteralExpr("jay-babu/mason-null-ls.nvim"), tag=Tag.LANGUAGE),
    Plugin(
        LiteralExpr("hrsh7th/nvim-cmp"),
        prop=Exprs(
            [
                EventProp("InsertEnter", "CmdlineEnter"),
                DependenciesProp(
                    "hrsh7th/cmp-nvim-lsp",
                    "hrsh7th/cmp-buffer",
                    "hrsh7th/cmp-path",
                    "hrsh7th/cmp-cmdline",
                    "L3MON4D3/LuaSnip",
                    "saadparwaiz1/cmp_luasnip",
                ),
            ],
            delimiter=", ",
        ),
        tag=Tag.LANGUAGE,
    ),
    # Language support
    Plugin(
        LiteralExpr("iamcco/markdown-preview.nvim"),
        prop=Exprs(
            [
                BuildProp("cd app && npm install"),
                AssignExpr(
                    LiteralExpr("init"),
                    LiteralExpr('function() vim.g.mkdp_filetypes = { "markdown" } end'),
                ),
                FtProp("markdown"),
            ],
            delimiter=", ",
        ),
        above=Exprs(
            [BigComment("Language support"), SmallComment("Markdown")], delimiter="\n"
        ),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("p00f/clangd_extensions.nvim"),
        above=SmallComment("Clangd extension"),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("justinmk/vim-syntax-extra"),
        prop=FtProp("lex", "flex", "yacc", "bison"),
        above=SmallComment("Lex/yacc, flex/bison"),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("rhysd/vim-llvm"),
        prop=FtProp("llvm", "mir", "mlir", "tablegen"),
        above=SmallComment("LLVM"),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("zebradil/hive.vim"),
        prop=FtProp("hive"),
        above=SmallComment("Hive"),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("slim-template/vim-slim"),
        prop=FtProp("slim"),
        above=SmallComment("Slim"),
        tag=Tag.LANGUAGE,
    ),
    # Movement
    Plugin(
        LiteralExpr("phaazon/hop.nvim"),
        prop=Exprs(
            [
                BranchProp("v2"),
                EventProp("VeryLazy"),
            ],
            delimiter=", ",
        ),
        above=Exprs(
            [BigComment("Movement"), SmallComment("Cursor Movement")], delimiter="\n"
        ),
        tag=Tag.EDITING,
    ),
    Plugin(
        LiteralExpr("ggandor/leap.nvim"),
        prop=Exprs(
            [
                DependenciesProp("tpope/vim-repeat"),
                EventProp("VeryLazy"),
            ],
            delimiter=", ",
        ),
        tag=Tag.EDITING,
    ),
    Plugin(
        LiteralExpr("chaoren/vim-wordmotion"),
        prop=EventProp("VeryLazy"),
        tag=Tag.EDITING,
    ),
    # Editing enhancement
    Plugin(
        LiteralExpr("alvan/vim-closetag"),
        prop=EventProp("InsertEnter"),
        above=Exprs(
            [BigComment("Editing enhancement"), SmallComment("HTML tag")],
            delimiter="\n",
        ),
        tag=Tag.EDITING,
    ),
    Plugin(
        LiteralExpr("numToStr/Comment.nvim"),
        prop=EventProp("VeryLazy"),
        above=SmallComment("Comment"),
        tag=Tag.EDITING,
    ),
    Plugin(
        LiteralExpr("windwp/nvim-autopairs"),
        prop=EventProp("InsertEnter"),
        above=SmallComment("Autopair"),
        tag=Tag.EDITING,
    ),
    Plugin(
        LiteralExpr("haya14busa/is.vim"),
        above=SmallComment("Incremental search"),
        tag=Tag.EDITING,
    ),
    Plugin(
        LiteralExpr("tpope/vim-repeat"),
        above=SmallComment("Other"),
        tag=Tag.EDITING,
    ),
    Plugin(
        LiteralExpr("mbbill/undotree"),
        prop=EventProp("VeryLazy"),
        tag=Tag.EDITING,
    ),
    Plugin(
        LiteralExpr("editorconfig/editorconfig-vim"),
        prop=EventProp("VeryLazy"),
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
        colors = []
        for ctx in PLUGINS:
            assert isinstance(ctx, Plugin)
            # above
            if ctx.above:
                plugins.append(ctx.above)
            # body
            if not self.is_disabled(ctx):
                # plugins
                prop = ctx.prop
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
                    prop = Exprs(
                        [
                            prop,
                            LiteralExpr(f"init = function() {' '.join(inits)} end"),
                        ],
                        delimiter=", ",
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
                    prop = Exprs(
                        [
                            prop,
                            LiteralExpr(f"config = function() {' '.join(configs)} end"),
                        ],
                        delimiter=", ",
                    )

                plugins.append(
                    Stmt(IndentExpr(CommaExpr(LazySpecExpr4Lua(ctx.repo, prop))))
                )
                # color settings
                if ctx.tag == Tag.COLORSCHEME:
                    colors.append(
                        Stmt(
                            IndentExpr(
                                LineContinuationExpr(
                                    CommaExpr(SingleQuoteStringExpr(ctx.color))
                                )
                            )
                        )
                    )
        return plugins, colors

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
