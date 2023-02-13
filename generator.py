#!/usr/bin/env python3

import abc
import argparse
import datetime
import enum
import pathlib
import platform

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
INDENT = " " * INDENT_SIZE


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
        for e in exprs:
            assert isinstance(e, Expr)
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
    def __init__(self, repo, props=None):
        assert isinstance(repo, Expr)
        assert isinstance(props, Expr) or props is None
        self.repo = repo
        self.props = props

    def render(self):
        if not self.props:
            return f"{INDENT}'{self.repo.render()}'"
        else:
            return f"""{INDENT}{{
{INDENT * 2}'{self.repo.render()}',{self.props.render()}
{INDENT}}}"""


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
            [p for p in self.props],
            delimiter=f",\n{INDENT * 2}",
            begin=f"\n{INDENT * 2}",
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


class VEventProp(EventProp):
    def __init__(self) -> None:
        super(VEventProp, self).__init__("VimEnter")


class CEventProp(EventProp):
    def __init__(self) -> None:
        super(CEventProp, self).__init__("CmdlineEnter")


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


class KeyProp(Prop):
    def __init__(self, *value) -> None:
        self.expr = AssignExpr(
            LiteralExpr("keys"),
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
        props=None,
        comments=None,
        color=None,
        tag=None,
    ) -> None:
        assert isinstance(repo, str)
        assert isinstance(props, Props) or props is None
        assert (
            isinstance(comments, Expr)
            or isinstance(comments, list)
            or isinstance(comments, str)
            or comments is None
        )
        assert isinstance(color, str) or color is None
        assert isinstance(tag, Tag)
        self.repo = LiteralExpr(repo)  # https://github.com/{org}/{repo}
        self.props = props  # more plugin properties following this line
        if isinstance(comments, list):
            self.comments = Exprs(comments)
        elif isinstance(comments, str):
            self.comments = SmallComment(comments)
        else:
            self.comments = comments
        self.color = color
        self.tag = tag

    def __str__(self):
        return self.repo.render() if isinstance(self.repo, Expr) else str(self.repo)


PLUGINS = [
    # { Infrastructure and dependencies
    Plugin(
        "nathom/filetype.nvim",
        comments=BigComment("Infrastructure"),
        tag=Tag.INFRASTRUCTURE,
    ),
    Plugin(
        "nvim-lua/plenary.nvim",
        props=Props(LazyProp()),
        tag=Tag.INFRASTRUCTURE,
    ),
    # } Infrastructure and dependencies
    # { Colorscheme
    Plugin(
        "bluz71/vim-nightfly-colors",
        props=ColorProps(),
        comments=BigComment("Colorscheme"),
        color="nightfly",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "bluz71/vim-moonfly-colors",
        props=ColorProps(),
        color="moonfly",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "catppuccin/nvim",
        props=ColorProps(NameProp("catppuccin")),
        color="catppuccin",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "challenger-deep-theme/vim",
        props=ColorProps(NameProp("challenger-deep")),
        color="challenger_deep",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "cocopon/iceberg.vim",
        props=ColorProps(),
        color="iceberg",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "EdenEast/nightfox.nvim",
        props=ColorProps(),
        color="nightfox",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "embark-theme/vim",
        props=ColorProps(NameProp("embark")),
        color="embark",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "fenetikm/falcon",
        props=ColorProps(),
        color="falcon",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "folke/tokyonight.nvim",
        props=ColorProps(BranchProp("main")),
        color="tokyonight",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "ishan9299/nvim-solarized-lua",
        props=ColorProps(),
        comments="inherit 'lifepillar/vim-solarized8'",
        color="solarized",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "junegunn/seoul256.vim",
        props=ColorProps(),
        color="seoul256",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "luisiacc/gruvbox-baby",
        props=ColorProps(BranchProp("main")),
        comments="inherit sainnhe/gruvbox-material",
        color="gruvbox-baby",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "marko-cerovac/material.nvim",
        props=ColorProps(),
        comments="inherit kaicataldo/material.vim",
        color="material",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "mhartington/oceanic-next",
        props=ColorProps(),
        color="OceanicNext",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "Mofiqul/dracula.nvim",
        props=ColorProps(),
        comments="inherit dracula/vim",
        color="dracula",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "navarasu/onedark.nvim",
        props=ColorProps(),
        comments="inherit joshdick/onedark.vim, tomasiser/vim-code-dark, olimorris/onedarkpro.nvim",
        color="onedark",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "NLKNguyen/papercolor-theme",
        props=ColorProps(),
        color="PaperColor",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "pineapplegiant/spaceduck",
        props=ColorProps(BranchProp("main")),
        color="spaceduck",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "preservim/vim-colors-pencil",
        props=ColorProps(),
        color="pencil",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "projekt0n/github-nvim-theme",
        props=ColorProps(),
        color="github_dark",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "raphamorim/lucario",
        props=ColorProps(),
        color="lucario",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "rebelot/kanagawa.nvim",
        props=ColorProps(),
        color="kanagawa",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "Rigellute/rigel",
        props=ColorProps(),
        color="rigel",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "romainl/Apprentice",
        props=ColorProps(),
        color="apprentice",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "rose-pine/neovim",
        props=ColorProps(NameProp("rose-pine")),
        color="rose-pine",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "sainnhe/edge",
        props=ColorProps(),
        color="edge",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "sainnhe/everforest",
        props=ColorProps(),
        color="everforest",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "sainnhe/sonokai",
        props=ColorProps(),
        comments="inherit sickill/vim-monokai",
        color="sonokai",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "shaunsingh/nord.nvim",
        props=ColorProps(),
        color="nord",
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "srcery-colors/srcery-vim",
        props=ColorProps(),
        color="srcery",
        tag=Tag.COLORSCHEME,
    ),
    # } Colorscheme
    # { Highlight
    Plugin(
        "RRethy/vim-illuminate",
        props=Props(VLEventProp()),
        comments=BigComment("Highlight"),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        "NvChad/nvim-colorizer.lua",
        props=Props(VLEventProp()),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        "andymass/vim-matchup",
        props=Props(VLEventProp()),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        "inkarkat/vim-mark",
        props=Props(DependenciesProp("inkarkat/vim-ingo-library"), VLEventProp()),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        "inkarkat/vim-ingo-library",
        props=Props(LazyProp()),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        "haya14busa/is.vim",
        props=Props(VLEventProp()),
        tag=Tag.HIGHLIGHT,
    ),
    # Plugin(
    #     "winston0410/range-highlight.nvim",
    #     props=Props(CEventProp(), DependenciesProp("winston0410/cmd-parser.nvim")),
    #     tag=Tag.HIGHLIGHT,
    # ),
    # Plugin(
    #     "winston0410/cmd-parser.nvim",
    #     props=Props(LazyProp()),
    #     tag=Tag.HIGHLIGHT,
    # ),
    Plugin("markonm/traces.vim", props=Props(CEventProp()), tag=Tag.HIGHLIGHT),
    # } Highlight
    # { UI
    # Plugin(
    #     "nvim-tree/nvim-tree.lua",
    #     props=Props(VEventProp(), DependenciesProp("nvim-tree/nvim-web-devicons")),
    #     above=Exprs([BigComment("UI"), SmallComment("File explorer")]),
    #     tag=Tag.UI,
    # ),
    Plugin(
        "nvim-neo-tree/neo-tree.nvim",
        props=Props(
            BranchProp("v2.x"),
            VEventProp(),
            DependenciesProp(
                "nvim-lua/plenary.nvim",
                "nvim-tree/nvim-web-devicons",
                "MunifTanjim/nui.nvim",
            ),
        ),
        comments=[BigComment("UI"), SmallComment("File explorer")],
        tag=Tag.UI,
    ),
    Plugin(
        "MunifTanjim/nui.nvim",
        props=Props(LazyProp()),
        tag=Tag.UI,
    ),
    Plugin(
        "nvim-tree/nvim-web-devicons",
        props=Props(LazyProp()),
        tag=Tag.UI,
    ),
    Plugin(
        "akinsho/bufferline.nvim",
        props=Props(
            VersionProp("v3.*"),
            VEventProp(),
            DependenciesProp("nvim-tree/nvim-web-devicons", "moll/vim-bbye"),
        ),
        comments="Tabline",
        tag=Tag.UI,
    ),
    Plugin(
        "moll/vim-bbye",
        props=Props(CEventProp()),
        tag=Tag.UI,
    ),
    Plugin(
        "lukas-reineke/indent-blankline.nvim",
        props=Props(VLEventProp()),
        comments="Indentline",
        tag=Tag.UI,
    ),
    Plugin(
        "nvim-lualine/lualine.nvim",
        props=Props(
            VEventProp(),
            DependenciesProp(
                "nvim-tree/nvim-web-devicons",
                "linrongbin16/lsp-progress.nvim",
                # "itchyny/vim-gitbranch", # use lualine's builtin 'branch'
            ),
        ),
        comments="Statusline",
        tag=Tag.UI,
    ),
    Plugin(
        "linrongbin16/lsp-progress.nvim",
        props=Props(BranchProp("main"), LazyProp()),
        tag=Tag.UI,
    ),
    # Plugin(
    #     "itchyny/vim-gitbranch",
    #     props=Props(VEventProp()),
    #     tag=Tag.UI,
    # ),
    Plugin(
        "utilyre/barbecue.nvim",
        props=Props(
            NameProp("barbecue"),
            VersionProp("*"),
            # BranchProp("fix/E36"), see: https://github.com/utilyre/barbecue.nvim/issues/61
            VLEventProp(),
            DependenciesProp("SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons"),
        ),
        tag=Tag.UI,
    ),
    Plugin(
        "SmiteshP/nvim-navic",
        props=Props(LazyProp(), DependenciesProp("neovim/nvim-lspconfig")),
        tag=Tag.UI,
    ),
    # Plugin(
    #     "lewis6991/gitsigns.nvim",
    #     props=Props(VLEventProp()),
    #     above="Git",
    #     tag=Tag.UI,
    # ),
    Plugin(
        "airblade/vim-gitgutter",
        props=Props(VLEventProp()),
        comments="Git",
        tag=Tag.UI,
    ),
    Plugin(
        "f-person/git-blame.nvim",
        props=Props(VLEventProp()),
        tag=Tag.UI,
    ),
    Plugin(
        "stevearc/dressing.nvim",
        props=Props(VLEventProp()),
        comments="UI hooks",
        tag=Tag.UI,
    ),
    # Plugin(
    #     "glepnir/lspsaga.nvim",
    #     props=Props(
    #         EventProp("BufRead"), DependenciesProp("nvim-tree/nvim-web-devicons")
    #     ),
    #     tag=Tag.UI
    # ),
    # Plugin("smjonas/inc-rename.nvim", props=Props(VLEventProp()), tag=Tag.UI),
    # } UI
    # { Search
    Plugin(
        "junegunn/fzf",
        props=Props(VEventProp(), BuildProp(":call fzf#install()")),
        comments=BigComment("Search"),
        tag=Tag.SEARCH,
    ),
    Plugin(
        "junegunn/fzf.vim",
        props=Props(VEventProp(), DependenciesProp("junegunn/fzf")),
        tag=Tag.SEARCH,
    ),
    # Plugin(
    #     "ojroques/nvim-lspfuzzy",
    #     props=Props(VEventProp(), DependenciesProp("junegunn/fzf", "junegunn/fzf.vim")),
    #     tag=Tag.SEARCH,
    # ),
    # } Search
    # { LSP
    Plugin(
        "liuchengxu/vista.vim",
        props=Props(VLEventProp(), DependenciesProp("ludovicchabant/vim-gutentags")),
        comments=[BigComment("LSP"), SmallComment("Tags/structure outlines")],
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "ludovicchabant/vim-gutentags",
        props=Props(VLEventProp()),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "williamboman/mason.nvim",
        props=Props(VLEventProp()),
        comments="LSP server management",
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "williamboman/mason-lspconfig.nvim",
        props=Props(
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
        "neovim/nvim-lspconfig",
        props=Props(LazyProp()),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "p00f/clangd_extensions.nvim",
        props=Props(LazyProp()),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "jose-elias-alvarez/null-ls.nvim",
        props=Props(VLEventProp(), DependenciesProp("nvim-lua/plenary.nvim")),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "jay-babu/mason-null-ls.nvim",
        props=Props(
            VLEventProp(),
            DependenciesProp(
                "williamboman/mason.nvim", "jose-elias-alvarez/null-ls.nvim"
            ),
        ),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "hrsh7th/nvim-cmp",
        props=Props(
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
        comments="Auto-complete engine",
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "hrsh7th/cmp-nvim-lsp",
        props=Props(ICEventProp()),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "hrsh7th/cmp-buffer",
        props=Props(ICEventProp()),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "hrsh7th/cmp-path",
        props=Props(ICEventProp()),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "hrsh7th/cmp-cmdline",
        props=Props(ICEventProp()),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "L3MON4D3/LuaSnip",
        props=Props(ICEventProp(), VersionProp("1.*")),
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "saadparwaiz1/cmp_luasnip",
        props=Props(ICEventProp(), DependenciesProp("L3MON4D3/LuaSnip")),
        tag=Tag.LANGUAGE,
    ),
    Plugin("DNLHC/glance.nvim", props=Props(VLEventProp()), tag=Tag.LANGUAGE),
    # } LSP
    # { Language support
    Plugin(
        "iamcco/markdown-preview.nvim",
        props=Props(
            BuildProp("cd app && npm install"),
            AssignExpr(
                LiteralExpr("init"),
                LiteralExpr('function() vim.g.mkdp_filetypes = { "markdown" } end'),
            ),
            FtProp("markdown"),
        ),
        comments=[BigComment("Language support"), SmallComment("Markdown")],
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "justinmk/vim-syntax-extra",
        props=Props(FtProp("lex", "flex", "yacc", "bison")),
        comments="Lex/yacc, flex/bison",
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "rhysd/vim-llvm",
        props=Props(FtProp("llvm", "mir", "mlir", "tablegen")),
        comments="LLVM",
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "zebradil/hive.vim",
        props=Props(FtProp("hive")),
        comments="Hive",
        tag=Tag.LANGUAGE,
    ),
    Plugin(
        "slim-template/vim-slim",
        props=Props(FtProp("slim")),
        comments="Slim",
        tag=Tag.LANGUAGE,
    ),
    # } Language support
    # { Motion
    Plugin(
        "phaazon/hop.nvim",
        props=Props(BranchProp("v2"), VEventProp()),
        comments=BigComment("Cursor Motion"),
        tag=Tag.EDITING,
    ),
    Plugin(
        "ggandor/leap.nvim",
        props=Props(VEventProp(), DependenciesProp("tpope/vim-repeat")),
        tag=Tag.EDITING,
    ),
    # } Motion
    # { Editing enhancement
    Plugin(
        "windwp/nvim-autopairs",
        props=Props(IEventProp()),
        comments=[BigComment("Editing enhancement"), SmallComment("Auto pair/close")],
        tag=Tag.EDITING,
    ),
    Plugin(
        "alvan/vim-closetag",
        props=Props(IEventProp()),
        tag=Tag.EDITING,
    ),
    Plugin(
        "numToStr/Comment.nvim",
        props=Props(VLEventProp()),
        comments="Comment",
        tag=Tag.EDITING,
    ),
    Plugin(
        "ruifm/gitlinker.nvim",
        props=Props(VLEventProp(), DependenciesProp("nvim-lua/plenary.nvim")),
        comments="Open In Github/Gitlab/etc",
        tag=Tag.EDITING,
    ),
    Plugin(
        "folke/which-key.nvim",
        props=Props(VLEventProp()),
        comments="Key mappings",
        tag=Tag.EDITING,
    ),
    Plugin(
        "akinsho/toggleterm.nvim",
        props=Props(VersionProp("*"), VLEventProp()),
        comments="Terminal",
        tag=Tag.EDITING,
    ),
    Plugin(
        "mbbill/undotree",
        props=Props(VLEventProp()),
        comments="Undo tree",
        tag=Tag.EDITING,
    ),
    Plugin(
        "tpope/vim-repeat",
        props=Props(VLEventProp()),
        comments="Other",
        tag=Tag.EDITING,
    ),
    Plugin(
        "kylechui/nvim-surround",
        props=Props(VersionProp("*"), VLEventProp()),
        tag=Tag.EDITING,
    ),
    Plugin(
        "editorconfig/editorconfig-vim",
        props=Props(VLEventProp()),
        tag=Tag.EDITING,
    ),
    # } Editing enhancement
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
            # comments
            if ctx.comments:
                plugins.append(ctx.comments)
            # body
            if not self.is_disabled(ctx):
                # props
                props = ctx.props
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
                    LINE_INDENT = "\n" + (INDENT * 3)
                    return f"""function(){LINE_INDENT}{LINE_INDENT.join(lines)}
{INDENT * 2}end"""

                def init_function_formatter(lines):
                    return f"init = {function_formatter(lines)}"

                def config_function_formatter(lines):
                    return f"config = {function_formatter(lines)}"

                # init
                inits = []
                if pathlib.Path(vim_init_file).exists():
                    inits.append(source_formatter(vim_init))
                if pathlib.Path(lua_init_file).exists():
                    inits.append(require_formatter(lua_init))
                if len(inits) > 0:
                    if isinstance(props, Props):
                        props.append(LiteralExpr(init_function_formatter(inits)))
                    else:
                        assert props is None
                        props = Props(LiteralExpr(init_function_formatter(inits)))
                # config
                configs = []
                if pathlib.Path(vim_config_file).exists():
                    configs.append(source_formatter(vim_config))
                if pathlib.Path(lua_config_file).exists():
                    configs.append(require_formatter(lua_config))
                if len(configs) > 0:
                    if isinstance(props, Props):
                        props.append(LiteralExpr(config_function_formatter(configs)))
                    else:
                        assert props is None
                        props = Props(LiteralExpr(config_function_formatter(configs)))

                plugins.append(Stmt(CommaExpr(LazySpecExpr4Lua(ctx.repo, props))))

                # colors
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


# class CommandHelp(click.Command):
#     HELP_FILE = pathlib.Path(f"{NVIM_DIR}/deps/help.txt")
#
#     def format_help(self, ctx, formatter):
#         with open(CommandHelp.HELP_FILE, "r") as hf:
#             formatter.write(hf.read())


# @click.command(cls=CommandHelp)
# @click.option("-b", "--basic", "basic_opt", is_flag=True, help="Basic mode")
# @click.option("-l", "--limit", "limit_opt", is_flag=True, help="Limit mode")
# @click.option(
#     "--use-color",
#     "use_color_opt",
#     default=None,
#     show_default=True,
#     help="Use static colorscheme",
# )
# @click.option(
#     "--no-color",
#     "no_color_opt",
#     is_flag=True,
#     help="No extra colors",
# )
# @click.option(
#     "--no-hilight",
#     "no_hilight_opt",
#     is_flag=True,
#     help="No extra highlights",
# )
# @click.option(
#     "--no-lang",
#     "no_lang_opt",
#     is_flag=True,
#     help="No language supports",
# )
# @click.option(
#     "--no-edit",
#     "no_edit_opt",
#     is_flag=True,
#     help="No editing enhancements",
# )
# @click.option(
#     "--no-plug",
#     "no_plug_opt",
#     multiple=True,
#     help="No specific plugin",
# )
# @click.option(
#     "--no-ctrl",
#     "no_ctrl_opt",
#     is_flag=True,
#     help="No Windows ctrl+?(and cmd+? on macOS) keys",
# )
# @click.option(
#     "--dump-plugins",
#     "dump_plugins_opt",
#     is_flag=True,
#     help="Dump all plugin list",
# )
# @click.option(
#     "--dump-plugins-filename",
#     "dump_plugins_filename_opt",
#     default="dump_plugins.md",
#     help="Dump plugins filename, by default: dump_plugins.md",
# )
# def generator(
#     basic_opt,
#     limit_opt,
#     use_color_opt,
#     no_color_opt,
#     no_hilight_opt,
#     no_lang_opt,
#     no_edit_opt,
#     no_plug_opt,
#     no_ctrl_opt,
#     dump_plugins_opt,
#     dump_plugins_filename_opt,
# ):
#     if dump_plugins_opt:
#         return Dumper.plugins(dump_plugins_filename_opt)
#
#     if limit_opt:
#         no_color_opt = True
#         no_hilight_opt = True
#         no_lang_opt = True
#         no_edit_opt = True
#     render = Render(
#         use_color_opt,
#         no_color_opt,
#         no_hilight_opt,
#         no_lang_opt,
#         no_edit_opt,
#         no_plug_opt,
#         no_ctrl_opt,
#     )
#     plugins, lspservers, colorschemes, settings, init = render.render()
#     writer = FileWriter(plugins, lspservers, colorschemes, settings, init)
#     writer.write()


def make_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-b", "--basic", dest="basic_opt", action="store_true", help="basic mode"
    )
    parser.add_argument(
        "-l", "--limit", dest="limit_opt", action="store_true", help="limit mode"
    )
    parser.add_argument(
        "--use-color",
        dest="use_color_opt",
        metavar="NAME",
        help="use specific colorscheme",
    )
    parser.add_argument(
        "--no-color", dest="no_color_opt", action="store_true", help="no extra colors"
    )
    parser.add_argument(
        "--no-hilight",
        dest="no_hilight_opt",
        action="store_true",
        help="no extra highlights",
    )
    parser.add_argument(
        "--no-lang", dest="no_lang_opt", action="store_true", help="no language support"
    )
    parser.add_argument(
        "--no-edit",
        dest="no_edit_opt",
        action="store_true",
        help="no editing enhancements",
    )
    parser.add_argument(
        "--no-plug",
        dest="no_plug_opt",
        metavar="ORG/REPO",
        action="append",
        help="no specific plugin",
    )
    parser.add_argument(
        "--no-ctrl",
        dest="no_ctrl_opt",
        action="store_true",
        help="no ctrl+?/cmd+? keys",
    )
    parser.add_argument(
        "--dump-plugins",
        dest="dump_plugins_opt",
        action="store_true",
        help="dump plugin list",
    )
    parser.add_argument(
        "--dump-plugins-file",
        dest="dump_plugins_file_opt",
        default="dump-plugins.md",
        metavar="FILE",
        help="file to dump plugin list",
    )
    arguments = parser.parse_args()
    return arguments


if __name__ == "__main__":
    arguments = make_arguments()
    print(arguments)

    if arguments.dump_plugins_opt:
        Dumper.plugins(arguments.dump_plugins_filename_opt)
        exit(0)

    if arguments.limit_opt:
        arguments.no_color_opt = True
        arguments.no_hilight_opt = True
        arguments.no_lang_opt = True
        arguments.no_edit_opt = True
    render = Render(
        arguments.use_color_opt,
        arguments.no_color_opt,
        arguments.no_hilight_opt,
        arguments.no_lang_opt,
        arguments.no_edit_opt,
        arguments.no_plug_opt,
        arguments.no_ctrl_opt,
    )
    plugins, lspservers, colorschemes, settings, init = render.render()
    writer = FileWriter(plugins, lspservers, colorschemes, settings, init)
    writer.write()
