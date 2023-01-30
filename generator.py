#!/usr/bin/env python3

import abc
import datetime
import enum
import pathlib
import platform

import click

HOME_DIR = pathlib.Path.home()
NVIM_DIR = pathlib.Path(f"{HOME_DIR}/.nvim")
TEMPLATE_DIR = pathlib.Path(f"{NVIM_DIR}/temp")

IS_WINDOWS = platform.system().lower().startswith("win")
IS_MACOS = platform.system().lower().startswith("darwin")


def message(*args):
    print(f"[lin.nvim] - {' '.join(args)}")


def error_message(*args):
    print(f"[lin.nvim] - error! {' '.join(args)}")


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


class Exprs(Expr):
    def __init__(self, exprs, delimiter="", begin="", end=""):
        assert isinstance(delimiter, str)
        assert isinstance(begin, str)
        assert isinstance(end, str)
        assert isinstance(exprs, list)
        self.exprs = [e for e in exprs if e is not None]
        self.delimiter = delimiter
        self.begin = begin
        self.end = end

    def render(self):
        return (
            self.begin
            + self.delimiter.join([e.render() for e in self.exprs])
            + self.end
        )


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
            return f"\t'{self.repo.render()}'"
        else:
            return f"""\t{{
\t\t'{self.repo.render()}',{self.prop.render()}
\t}}"""


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


# Helper Expr {


class Prop(Expr):
    @abc.abstractmethod
    def render(self):
        pass


class Props(Prop):
    def __init__(self, *props):
        for p in props:
            assert isinstance(p, Expr)
        self.props = [p for p in props]

    def append(self, p):
        assert isinstance(p, Expr)
        self.props.append(p)

    def render(self):
        return Exprs(
            [p for p in self.props], delimiter=",\n\t\t", begin="\n\t\t"
        ).render()


class LazyProp(Prop):
    def __init__(self, value="true"):
        assert value == "true" or value == "false"
        self.expr = AssignExpr(LiteralExpr("lazy"), LiteralExpr(value))

    def render(self):
        return self.expr.render()


class PriorityProp(Prop):
    def __init__(self, value) -> None:
        self.expr = AssignExpr(LiteralExpr("priority"), LiteralExpr(value))

    def render(self):
        return self.expr.render()


class ColorProps(Props):
    def __init__(self, *props):
        super(ColorProps, self).__init__(LazyProp(), PriorityProp(1000), *props)


class BigComment(Expr):
    def __init__(self, *value):
        assert value is not None
        stmts = []
        stmts.append(EmptyStmt())
        stmts.extend(
            [
                Stmt(IndentExpr(CommentExpr4Lua(LiteralExpr(f"---- {v} ----"))))
                for v in value
            ]
        )
        stmts.append(EmptyStmt())
        self.expr = Exprs(stmts)

    def render(self):
        return self.expr.render()


class SmallComment(Expr):
    def __init__(self, *value):
        assert value is not None
        stmts = []
        stmts.extend([Stmt(IndentExpr(CommentExpr4Lua(LiteralExpr(v)))) for v in value])
        self.expr = Exprs(stmts)

    def render(self):
        return self.expr.render()


class NameProp(Prop):
    def __init__(self, value):
        assert isinstance(value, str)
        self.expr = AssignExpr(LiteralExpr("name"), SingleQuoteStringExpr(value))

    def render(self):
        return self.expr.render()


class BranchProp(Prop):
    def __init__(self, value):
        assert isinstance(value, str)
        self.expr = AssignExpr(LiteralExpr("branch"), SingleQuoteStringExpr(value))

    def render(self):
        return self.expr.render()


class EventProp(Prop):
    def __init__(self, *value) -> None:
        self.expr = AssignExpr(
            LiteralExpr("event"),
            BracedExpr4Lua(
                Exprs([SingleQuoteStringExpr(v) for v in value], delimiter=", ")
            ),
        )

    def render(self):
        return self.expr.render()


class VLEventProp(EventProp):
    def __init__(self) -> None:
        super(VLEventProp, self).__init__("VeryLazy")


class ICEventProp(EventProp):
    def __init__(self) -> None:
        super(ICEventProp, self).__init__("InsertEnter", "CmdlineEnter")


class IEventProp(EventProp):
    def __init__(self) -> None:
        super(IEventProp, self).__init__("InsertEnter")


class DependenciesProp(Prop):
    def __init__(self, *value):
        self.expr = AssignExpr(
            LiteralExpr("dependencies"),
            BracedExpr4Lua(
                Exprs([SingleQuoteStringExpr(v) for v in value], delimiter=", ")
            ),
        )

    def render(self):
        return self.expr.render()


class VersionProp(Prop):
    def __init__(self, value) -> None:
        assert isinstance(value, str)
        self.expr = AssignExpr(LiteralExpr("version"), SingleQuoteStringExpr(value))

    def render(self):
        return self.expr.render()


class BuildProp(Prop):
    def __init__(self, value) -> None:
        assert isinstance(value, str)
        self.expr = AssignExpr(LiteralExpr("build"), SingleQuoteStringExpr(value))

    def render(self):
        return self.expr.render()


class FtProp(Prop):
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


class Tag(enum.Enum):
    INFRASTRUCTURE = 1
    COLORSCHEME = 2
    HIGHLIGHT = 3
    UI = 4
    SEARCH = 5
    LANGUAGE = 6
    EDITING = 7


class Plugin:
    def __init__(
        self,
        repo,
        prop=None,
        above=None,
        color=None,
        tag=None,
    ) -> None:
        assert isinstance(repo, Expr)
        assert isinstance(tag, Tag)
        assert isinstance(prop, Props) or prop is None
        assert isinstance(above, Expr) or above is None
        assert isinstance(color, str) or color is None
        self.repo = repo  # https://github.com/{repo}
        self.prop = prop  # more plugin properties following this line
        self.above = above  # more clauses above this line
        self.color = color
        self.tag = tag

    def __str__(self):
        return self.repo.render() if isinstance(self.repo, Expr) else str(self.repo)


PLUGINS = [
    # Infrastructure
    Plugin(
        LiteralExpr("nathom/filetype.nvim"),
        above=BigComment("Infrastructure"),
        tag=Tag.INFRASTRUCTURE,
    ),
    # Colorscheme
    Plugin(
        LiteralExpr("bluz71/vim-nightfly-colors"),
        prop=ColorProps(),
        above=BigComment("Colorscheme"),
        color="nightfly",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("bluz71/vim-moonfly-colors"),
        prop=ColorProps(),
        color="moonfly",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("catppuccin/nvim"),
        prop=ColorProps(NameProp("catppuccin")),
        color="catppuccin",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("challenger-deep-theme/vim"),
        prop=ColorProps(NameProp("challenger-deep")),
        color="challenger_deep",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("cocopon/iceberg.vim"),
        prop=ColorProps(),
        color="iceberg",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("EdenEast/nightfox.nvim"),
        prop=ColorProps(),
        color="nightfox",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("embark-theme/vim"),
        prop=ColorProps(NameProp("embark")),
        color="embark",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("fenetikm/falcon"),
        prop=ColorProps(),
        color="falcon",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("folke/tokyonight.nvim"),
        prop=ColorProps(BranchProp("main")),
        color="tokyonight",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("ishan9299/nvim-solarized-lua"),
        prop=ColorProps(),
        above=SmallComment("inherit 'lifepillar/vim-solarized8'"),
        color="solarized",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("junegunn/seoul256.vim"),
        prop=ColorProps(),
        color="seoul256",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("luisiacc/gruvbox-baby"),
        prop=ColorProps(BranchProp("main")),
        above=SmallComment("inherit sainnhe/gruvbox-material"),
        color="gruvbox-baby",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("marko-cerovac/material.nvim"),
        prop=ColorProps(),
        above=SmallComment("inherit kaicataldo/material.vim"),
        color="material",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("mhartington/oceanic-next"),
        prop=ColorProps(),
        color="OceanicNext",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("Mofiqul/dracula.nvim"),
        prop=ColorProps(),
        above=SmallComment("inherit dracula/vim"),
        color="dracula",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("navarasu/onedark.nvim"),
        prop=ColorProps(),
        above=SmallComment(
            "inherit joshdick/onedark.vim, tomasiser/vim-code-dark, olimorris/onedarkpro.nvim"
        ),
        color="onedark",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("NLKNguyen/papercolor-theme"),
        prop=ColorProps(),
        color="PaperColor",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("pineapplegiant/spaceduck"),
        prop=ColorProps(BranchProp("main")),
        color="spaceduck",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("preservim/vim-colors-pencil"),
        prop=ColorProps(),
        color="pencil",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("projekt0n/github-nvim-theme"),
        prop=ColorProps(),
        color="github_dark",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("raphamorim/lucario"),
        prop=ColorProps(),
        color="lucario",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("rebelot/kanagawa.nvim"),
        prop=ColorProps(),
        color="kanagawa",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("Rigellute/rigel"),
        prop=ColorProps(),
        color="rigel",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("romainl/Apprentice"),
        prop=ColorProps(),
        color="apprentice",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("rose-pine/neovim"),
        prop=ColorProps(NameProp("rose-pine")),
        color="rose-pine",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("sainnhe/edge"),
        prop=ColorProps(),
        color="edge",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("sainnhe/everforest"),
        prop=ColorProps(),
        color="everforest",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("sainnhe/sonokai"),
        prop=ColorProps(),
        above=SmallComment("inherit sickill/vim-monokai"),
        color="sonokai",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("shaunsingh/nord.nvim"),
        prop=ColorProps(),
        color="nord",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        LiteralExpr("srcery-colors/srcery-vim"),
        prop=ColorProps(),
        color="srcery",
        tag=Tag.COLORSCHEME,
    ),
    # Highlight
    Plugin(
        LiteralExpr("RRethy/vim-illuminate"),
        prop=Props(VLEventProp()),
        above=BigComment("Highlight"),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        LiteralExpr("NvChad/nvim-colorizer.lua"),
        prop=Props(VLEventProp()),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        LiteralExpr("andymass/vim-matchup"),
        prop=Props(VLEventProp()),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        LiteralExpr("inkarkat/vim-mark"),
        prop=Props(DependenciesProp("inkarkat/vim-ingo-library"), VLEventProp()),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        LiteralExpr("inkarkat/vim-ingo-library"),
        prop=Props(LazyProp()),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        LiteralExpr("nvim-tree/nvim-tree.lua"),
        prop=Props(
            EventProp("VimEnter"), DependenciesProp("nvim-tree/nvim-web-devicons")
        ),
        above=Exprs([BigComment("UI"), SmallComment("File explorer")]),
        tag=Tag.UI,
    ),
    Plugin(
        LiteralExpr("nvim-tree/nvim-web-devicons"),
        prop=Props(LazyProp()),
        tag=Tag.UI,
    ),
    Plugin(
        LiteralExpr("akinsho/bufferline.nvim"),
        prop=Props(
            VersionProp("v3.*"),
            EventProp("VimEnter"),
            DependenciesProp("nvim-tree/nvim-web-devicons", "moll/vim-bbye"),
        ),
        above=SmallComment("Tabline"),
        tag=Tag.UI,
    ),
    Plugin(
        LiteralExpr("moll/vim-bbye"),
        prop=Props(VLEventProp()),
        tag=Tag.UI,
    ),
    Plugin(
        LiteralExpr("lukas-reineke/indent-blankline.nvim"),
        prop=Props(VLEventProp()),
        above=SmallComment("Indentline"),
        tag=Tag.UI,
    ),
    Plugin(
        LiteralExpr("nvim-lualine/lualine.nvim"),
        prop=Props(
            VLEventProp(),
            DependenciesProp("nvim-tree/nvim-web-devicons", "nvim-lua/lsp-status.nvim"),
        ),
        above=SmallComment("Statusline"),
        tag=Tag.UI,
    ),
    Plugin(
        LiteralExpr("nvim-lua/lsp-status.nvim"),
        prop=Props(VLEventProp()),
        tag=Tag.UI,
    ),
    Plugin(
        LiteralExpr("lewis6991/gitsigns.nvim"),
        prop=Props(VLEventProp()),
        above=SmallComment("Git"),
        tag=Tag.UI,
    ),
    Plugin(
        LiteralExpr("akinsho/toggleterm.nvim"),
        prop=Props(VersionProp("*"), VLEventProp()),
        above=SmallComment("Terminal"),
        tag=Tag.UI,
    ),
    Plugin(
        LiteralExpr("stevearc/dressing.nvim"),
        prop=Props(VLEventProp()),
        above=SmallComment("UI hooks"),
        tag=Tag.UI,
    ),
    # Plugin(
    #     LiteralExpr("glepnir/lspsaga.nvim"),
    #     prop=Props(
    #         EventProp("BufRead"), DependenciesProp("nvim-tree/nvim-web-devicons")
    #     ),
    #     tag=Tag.UI
    # ),
    # Plugin(LiteralExpr("smjonas/inc-rename.nvim"), prop=Props(VLEventProp()), tag=Tag.UI),
    # Search
    Plugin(
        LiteralExpr("junegunn/fzf"),
        prop=Props(VLEventProp(), BuildProp(":call fzf#install()")),
        above=BigComment("Search"),
        tag=Tag.SEARCH,
    ),
    Plugin(
        LiteralExpr("junegunn/fzf.vim"),
        prop=Props(VLEventProp(), DependenciesProp("junegunn/fzf")),
        tag=Tag.SEARCH,
    ),
    Plugin(
        LiteralExpr("ojroques/nvim-lspfuzzy"),
        prop=Props(VLEventProp(), DependenciesProp("junegunn/fzf", "junegunn/fzf.vim")),
        tag=Tag.SEARCH,
    ),
    # LSP server
    Plugin(
        LiteralExpr("liuchengxu/vista.vim"),
        prop=Props(VLEventProp(), DependenciesProp("ludovicchabant/vim-gutentags")),
        above=Exprs(
            [BigComment("LSP server"), SmallComment("Tags/structure outlines")]
        ),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("ludovicchabant/vim-gutentags"),
        prop=Props(VLEventProp()),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("williamboman/mason.nvim"),
        prop=Props(VLEventProp()),
        above=SmallComment("LSP server management"),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("williamboman/mason-lspconfig.nvim"),
        prop=Props(
            VLEventProp(),
            DependenciesProp(
                "williamboman/mason.nvim",
                "neovim/nvim-lspconfig",
                "p00f/clangd_extensions.nvim",
            ),
        ),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("neovim/nvim-lspconfig"),
        prop=Props(LazyProp()),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("p00f/clangd_extensions.nvim"),
        prop=Props(LazyProp()),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("jose-elias-alvarez/null-ls.nvim"),
        prop=Props(VLEventProp(), DependenciesProp("nvim-lua/plenary.nvim")),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("nvim-lua/plenary.nvim"), prop=Props(LazyProp()), tag=Tag.LANGUAGE
    ),
    Plugin(
        LiteralExpr("jay-babu/mason-null-ls.nvim"),
        prop=Props(
            VLEventProp(),
            DependenciesProp(
                "williamboman/mason.nvim", "jose-elias-alvarez/null-ls.nvim"
            ),
        ),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("hrsh7th/nvim-cmp"),
        prop=Props(
            ICEventProp(),
            DependenciesProp(
                "neovim/nvim-lspconfig",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-cmdline",
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
            ),
        ),
        above=SmallComment("Auto-complete engine"),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("hrsh7th/cmp-nvim-lsp"),
        prop=Props(ICEventProp()),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("hrsh7th/cmp-buffer"),
        prop=Props(ICEventProp()),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("hrsh7th/cmp-path"),
        prop=Props(ICEventProp()),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("hrsh7th/cmp-cmdline"),
        prop=Props(ICEventProp()),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("L3MON4D3/LuaSnip"),
        prop=Props(ICEventProp(), VersionProp("1.*")),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("saadparwaiz1/cmp_luasnip"),
        prop=Props(ICEventProp()),
        tag=Tag.LANGUAGE,
    ),
    # Language support
    Plugin(
        LiteralExpr("iamcco/markdown-preview.nvim"),
        prop=Props(
            BuildProp("cd app && npm install"),
            AssignExpr(
                LiteralExpr("init"),
                LiteralExpr('function() vim.g.mkdp_filetypes = { "markdown" } end'),
            ),
            FtProp("markdown"),
        ),
        above=Exprs([BigComment("Language support"), SmallComment("Markdown")]),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("justinmk/vim-syntax-extra"),
        prop=Props(FtProp("lex", "flex", "yacc", "bison")),
        above=SmallComment("Lex/yacc, flex/bison"),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("rhysd/vim-llvm"),
        prop=Props(FtProp("llvm", "mir", "mlir", "tablegen")),
        above=SmallComment("LLVM"),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("zebradil/hive.vim"),
        prop=Props(FtProp("hive")),
        above=SmallComment("Hive"),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        LiteralExpr("slim-template/vim-slim"),
        prop=Props(FtProp("slim")),
        above=SmallComment("Slim"),
        tag=Tag.LANGUAGE,
    ),
    # Movement
    Plugin(
        LiteralExpr("phaazon/hop.nvim"),
        prop=Props(BranchProp("v2"), VLEventProp()),
        above=Exprs([BigComment("Movement"), SmallComment("Cursor Movement")]),
        tag=Tag.EDITING,
    ),
    Plugin(
        LiteralExpr("ggandor/leap.nvim"),
        prop=Props(DependenciesProp("tpope/vim-repeat"), VLEventProp()),
        tag=Tag.EDITING,
    ),
    Plugin(
        LiteralExpr("chaoren/vim-wordmotion"),
        prop=Props(VLEventProp()),
        tag=Tag.EDITING,
    ),
    # Editing enhancement
    Plugin(
        LiteralExpr("windwp/nvim-autopairs"),
        prop=Props(IEventProp()),
        above=Exprs(
            [BigComment("Editing enhancement"), SmallComment("Auto pair/close")]
        ),
        tag=Tag.EDITING,
    ),
    Plugin(
        LiteralExpr("alvan/vim-closetag"),
        prop=Props(IEventProp()),
        tag=Tag.EDITING,
    ),
    Plugin(
        LiteralExpr("numToStr/Comment.nvim"),
        prop=Props(VLEventProp()),
        above=SmallComment("Comment"),
        tag=Tag.EDITING,
    ),
    Plugin(
        LiteralExpr("haya14busa/is.vim"),
        prop=Props(VLEventProp()),
        above=SmallComment("Incremental search"),
        tag=Tag.EDITING,
    ),
    Plugin(
        LiteralExpr("tpope/vim-repeat"),
        prop=Props(VLEventProp()),
        above=SmallComment("Other"),
        tag=Tag.EDITING,
    ),
    Plugin(
        LiteralExpr("mbbill/undotree"),
        prop=Props(VLEventProp()),
        tag=Tag.EDITING,
    ),
    Plugin(
        LiteralExpr("editorconfig/editorconfig-vim"),
        prop=Props(VLEventProp()),
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
        no_ctrl_opt=False,
    ):
        self.use_color = use_color
        self.no_color = no_color
        self.no_hilight = no_hilight
        self.no_lang = no_lang
        self.no_edit = no_edit
        self.no_plugs = no_plugs
        self.no_ctrl = no_ctrl_opt

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
            TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/plugins-header.lua"))
        )
        stmts.extend(core_plugins)
        stmts.append(
            TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/plugins-footer.lua"))
        )
        return stmts

    # init.vim
    def render_init(self):
        stmts = []
        stmts.append(TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/init.vim")))
        return stmts

    # lspservers.lua
    def render_lspservers(self):
        stmts = []
        if not self.no_lang:
            stmts.append(
                TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/lspservers.lua"))
            )
        return stmts

    # colorschemes.vim
    def render_colorschemes(self, core_color_settings):
        stmts = []
        stmts.append(
            TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/colorschemes-header.vim"))
        )
        stmts.extend(core_color_settings)
        stmts.append(
            TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/colorschemes-footer.vim"))
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
        if not self.no_ctrl:
            stmts.append(
                TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/ctrl-settings.vim"))
            )
        stmts.append(TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/settings.vim")))
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
                lua_init_file = f"{NVIM_DIR}/lua/{lua_init}.lua"
                lua_config = f"{lua_base}/config"
                lua_config_file = f"{NVIM_DIR}/lua/{lua_config}.lua"
                vim_base = f"repo/{ctx}"
                vim_init = f"{vim_base}/init.vim"
                vim_init_file = f"{NVIM_DIR}/{vim_init}"
                vim_config = f"{vim_base}/config.vim"
                vim_config_file = f"{NVIM_DIR}/{vim_config}"

                def require_formatter(s):
                    return RequireExpr(SingleQuoteStringExpr(s)).render()

                def source_formatter(s):
                    source = SourceExpr(LiteralExpr(f"$HOME/.nvim/{s}"))
                    return f"vim.cmd('{source.render()}')"

                def function_formatter(lines):
                    LINE_INDENT = "\n\t\t\t"
                    return f"""function(){LINE_INDENT}{LINE_INDENT.join(lines)}
\t\tend"""

                def init_function_formatter(lines):
                    return f"init = {function_formatter(lines)}"

                def config_function_formatter(lines):
                    return f"config = {function_formatter(lines)}"

                # init
                inits = []
                if pathlib.Path(lua_init_file).exists():
                    inits.append(require_formatter(lua_init))
                if pathlib.Path(vim_init_file).exists():
                    inits.append(source_formatter(vim_init))
                if len(inits) > 0:
                    if isinstance(prop, Props):
                        prop.append(LiteralExpr(init_function_formatter(inits)))
                    else:
                        assert prop is None
                        prop = Props(LiteralExpr(init_function_formatter(inits)))

                # config
                configs = []
                if pathlib.Path(lua_config_file).exists():
                    configs.append(require_formatter(lua_config))
                if pathlib.Path(vim_config_file).exists():
                    configs.append(source_formatter(vim_config))
                if len(configs) > 0:
                    if isinstance(prop, Props):
                        prop.append(LiteralExpr(config_function_formatter(configs)))
                    else:
                        assert prop is None
                        prop = Props(LiteralExpr(config_function_formatter(configs)))

                plugins.append(Stmt(CommaExpr(LazySpecExpr4Lua(ctx.repo, prop))))
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


class FileWriter:
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

    def write(self):
        self.config()
        self.init_vim()

    def config(self):
        pathlib.Path(f"{NVIM_DIR}/lua").mkdir(parents=True, exist_ok=True)

        plugins_lua = f"{NVIM_DIR}/lua/plugins.lua"
        try_backup(pathlib.Path(plugins_lua))
        with open(plugins_lua, "w") as fp:
            fp.write(self.plugins)

        lspservers_lua = f"{NVIM_DIR}/lua/lspservers.lua"
        try_backup(pathlib.Path(lspservers_lua))
        with open(lspservers_lua, "w") as fp:
            fp.write(self.lspservers)

        colorschemes_vim = f"{NVIM_DIR}/colorschemes.vim"
        try_backup(pathlib.Path(colorschemes_vim))
        with open(colorschemes_vim, "w") as fp:
            fp.write(self.colorschemes)

        settings_vim = f"{NVIM_DIR}/settings.vim"
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
        nvim_dir.symlink_to(str(NVIM_DIR), target_is_directory=True)

        init_vim = pathlib.Path(f"{NVIM_DIR}/init.vim")
        try_backup(pathlib.Path(init_vim))
        with open(init_vim, "w") as fp:
            fp.write(self.inits)


class Dumper:
    @staticmethod
    def plugins(filename):
        formatter = "- [{0}](https://github.com/{0})\n"
        with open(filename, "w") as fp:
            for t in Tag:
                fp.writelines(f"{t.name}\n")
                fp.writelines(
                    [formatter.format(p.repo.render()) for p in PLUGINS if p.tag == t]
                )
                fp.writelines("\n")


class CommandHelp(click.Command):
    HELP_FILE = pathlib.Path(f"{NVIM_DIR}/install/help.txt")

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
    "--no-ctrl",
    "no_ctrl_opt",
    is_flag=True,
    help="No Windows ctrl+?(and cmd+? on macOS) keys",
)
@click.option(
    "--dump-plugins",
    "dump_plugins_opt",
    is_flag=True,
    help="Dump all plugin list",
)
@click.option(
    "--dump-plugins-filename",
    "dump_plugins_filename_opt",
    default="dump_plugins.md",
    help="Dump plugins filename, by default: dump_plugins.md",
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
    no_ctrl_opt,
    dump_plugins_opt,
    dump_plugins_filename_opt,
):
    if dump_plugins_opt:
        return Dumper.plugins(dump_plugins_filename_opt)

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
        no_ctrl_opt,
    )
    plugins, lspservers, colorschemes, settings, init = render.render()
    writer = FileWriter(plugins, lspservers, colorschemes, settings, init)
    writer.write()


if __name__ == "__main__":
    generator()
