#!/usr/bin/env python3

import abc
import argparse
import datetime
import enum
import pathlib
import platform
import shutil
from collections import OrderedDict

HOME_DIR = pathlib.Path.home()
NVIM_DIR = pathlib.Path(f"{HOME_DIR}/.nvim")
TEMPLATE_DIR = pathlib.Path(f"{NVIM_DIR}/temp")

IS_WINDOWS = platform.system().lower().startswith("win")
IS_MACOS = platform.system().lower().startswith("darwin")
# IS_MACOS_SILICON_CHIP = platform.processor().startswith("arm") or (
#     platform.processor().startswith("i386")
#     and int(
#         subprocess.run(
#             ["sysctl", "-n", "sysctl.proc_translated"], capture_output=True, text=True
#         ).stdout
#     )
#     > 0
# )


def format_message(*args):
    return f"[lin.nvim] - {' '.join(args)}"


def message(*args):
    print(format_message(*[a for a in args]))


def error_message(*args):
    print(f"[lin.nvim] - error! {' '.join(args)}")


def try_backup(src):
    assert isinstance(src, pathlib.Path)
    if src.is_symlink() or src.exists():
        dest = f"{src}.{datetime.datetime.now().strftime('%Y-%m-%d.%H-%M-%S.%f')}"
        src.rename(dest)
        message(f"backup '{src}' to '{dest}'")


def dedup_list(l):
    return list(OrderedDict.fromkeys(l))


def has_command(cmd):
    return shutil.which(cmd) is not None


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


# Lsp {


class LangLsp:
    def __init__(self, name=None, command=[], lsp=[], nullls=[], checker=None):
        assert isinstance(name, str)
        assert isinstance(command, str) or isinstance(command, list)
        assert isinstance(lsp, str) or isinstance(lsp, list)
        assert isinstance(nullls, str) or isinstance(nullls, list)
        self.name = name
        self.command = [command] if isinstance(command, str) else command
        self.lsp = [lsp] if isinstance(lsp, str) else lsp
        self.nullls = [nullls] if isinstance(nullls, str) else nullls
        if checker:
            self.checker = checker
        else:
            self.checker = lambda cmd: all([has_command(c) for c in cmd])

    def confirm(self):
        recommends = dedup_list(self.lsp + self.nullls)
        candidates = ", ".join([f"{i+1}:{r}" for i, r in enumerate(recommends)])
        # Accept:
        #   * ENTER: select all
        #   * Numbers(separated by comma): select any
        #   * n/N: skip
        message("")
        result = input(
            format_message(
                f"detected '{self.name}' (by {'/'.join(self.command)}), install lsp({candidates})? "
            )
        )

        lsp_servers = []
        nullls_sources = []

        def add_candidate(c):
            if c in self.lsp:
                lsp_servers.append(c)
            else:
                assert c in self.nullls
                nullls_sources.append(c)

        confirmed = None

        if result.lower().startswith("n"):
            message(f"confirm denied")
            confirmed = False
        elif len(result.lower()) <= 0:
            message(f"confirmed all: {', '.join([r for r in recommends])}")
            for r in recommends:
                add_candidate(r)
            confirmed = True
        else:
            try:
                # tolerate extra commas, could be error input
                indexes = [int(i) for i in result.split(",") if len(i) > 0]
                choice = []
                for i in indexes:
                    if i < 1 or i > len(recommends):
                        error_message(f"unknown number: {i}, skip...")
                        return False, lsp_servers, nullls_sources
                    add_candidate(recommends[i - 1])
                    choice.append(recommends[i - 1])
                message(f"confirmed: {', '.join([c for c in choice])}")
                confirmed = True
            except:
                error_message(f"unknown choice: {result}, skip...")
                confirmed = False

        assert confirmed is not None
        return confirmed, lsp_servers, nullls_sources


LANGUAGE_LSPS = [
    LangLsp(
        name="assembly",
        command=["as", "rustc", "cargo"],
        lsp="asm_lsp",
    ),
    LangLsp(
        name="bash",
        command="bash",
        lsp="bashls",
    ),
    LangLsp(
        name="c/c++",
        command=["gcc", "g++", "clang", "clang++", "MSBuild", "cl"],
        lsp="clangd",
        nullls=["cpplint", "clang_format"],
        checker=lambda cmd: (has_command("gcc") and has_command("g++"))
        or (has_command("clang") and has_command("clang++"))
        or (has_command("MSBuild") and has_command("cl")),
    ),
    LangLsp(
        name="clojure",
        command="clj",
        lsp="clojure_lsp",
        nullls="joker",
    ),
    LangLsp(
        name="cmake",
        command="cmake",
        lsp=["cmake", "neocmake"],
    ),
    LangLsp(
        name="crystal",
        command="crystal",
        lsp="crystalline",
    ),
    LangLsp(
        name="csharp",
        command=["csc", "dotnet", "mcs"],
        lsp=["csharp_ls", "omnisharp_mono", "omnisharp"],
        nullls=["csharpier", "clang_format"],
        checker=lambda cmd: has_command("csc")
        or has_command("dotnet")
        or has_command("mcs"),
    ),
    LangLsp(
        name="css",
        command=["node", "npm"],
        lsp=["cssls", "cssmodules_ls", "unocss"],
    ),
    LangLsp(
        name="docker",
        command="docker",
        lsp="dockerls",
        nullls="hadolint",
    ),
    LangLsp(
        name="dot(graphviz)",
        command="dot",
        lsp="dotls",
    ),
    LangLsp(
        name="elixir",
        command="elixir",
        lsp="elixirls",
    ),
    LangLsp(
        name="erlang",
        command="erl",
        lsp="erlangls",
    ),
    LangLsp(
        name="fortran",
        command="gfortran",
        lsp="fortls",
    ),
    LangLsp(
        name="fsharp",
        command="dotnet",
        lsp="fsautocomplete",
    ),
    LangLsp(
        name="go",
        command="go",
        lsp=["golangci_lint_ls", "gopls"],
        nullls=[
            "gofumpt",
            "goimports",
            "goimports_reviser",
            "golangci_lint",
            "golines",
            "revive",
            "staticcheck",
        ],
    ),
    LangLsp(
        name="groovy",
        command="groovy",
        lsp="groovyls",
    ),
    LangLsp(
        name="haskell",
        command="ghc",
        lsp="hls",
    ),
    LangLsp(
        name="html",
        command=["node", "npm"],
        lsp="html",
        nullls="curlylint",
    ),
    LangLsp(
        name="java",
        command=["javac", "java"],
        lsp="jdtls",
        nullls="clang_format",
    ),
    LangLsp(
        name="javascript/typescript",
        command=["node", "npm"],
        lsp=["quick_lint_js", "tsserver", "vtsls", "eslint"],
        nullls=["rome", "xo", "eslint_d", "prettier", "prettierd"],
    ),
    LangLsp(
        name="json",
        command=["node", "npm"],
        lsp="jsonls",
        nullls=["fixjson", "jq", "cfn_lint"],
    ),
    LangLsp(
        name="julia",
        command="julia",
        lsp="julials",
        nullls=["fixjson", "jq"],
    ),
    LangLsp(
        name="kotlin",
        command="kotlinc",
        lsp="kotlin_language_server",
        nullls="ktlint",
    ),
    LangLsp(
        name="latex",
        command=["latex", "pdflatex", "xelatex"],
        lsp=["ltex", "texlab"],
        nullls=["proselint", "vale"],
        checker=lambda cmd: has_command("latex")
        or has_command("pdflatex")
        or has_command("xelatex"),
    ),
    LangLsp(
        name="lua",
        command="lua",
        lsp=["lua_ls"],
        nullls=["selene", "stylua"],
        checker=lambda cmd: True,  # lua is embeded
    ),
    LangLsp(
        name="luarocks",
        command=["lua", "luarocks"],
        nullls="luacheck",
    ),
    LangLsp(
        name="markdown",
        command=["node", "npm"],
        lsp=["marksman", "prosemd_lsp", "remark_ls", "zk"],
        nullls=["alex", "markdownlint", "write_good", "cbfmt", "proselint", "vale"],
    ),
    LangLsp(
        name="ocaml",
        command="ocaml",
        lsp=["ocamllsp"],
    ),
    LangLsp(
        name="perl",
        command="perl",
        lsp=["perlnavigator"],
    ),
    LangLsp(
        name="php",
        command="php",
        lsp=["intelephense", "phpactor", "psalm"],
        nullls=["phpcbf", "psalm"],
    ),
    LangLsp(
        name="powershell",
        command=["pwsh", "powershell"],
        lsp=["powershell_es"],
        checker=lambda cmd: has_command("pwsh") or has_command("powershell"),
    ),
    LangLsp(
        name="protobuf",
        command="protoc",
        lsp=["bufls"],
        nullls=["buf", "protolint"],
    ),
    LangLsp(
        name="python",
        command=["python", "python2", "python3"],
        lsp=[
            "jedi_language_server",
            "pyre",
            "pyright",
            "sourcery",
            "pylsp",
            "ruff_lsp",
        ],
        nullls=[
            "autopep8",
            "black",
            "blue",
            "flake8",
            "isort",
            "mypy",
            "pylint",
            "vulture",
            "yapf",
        ],
        checker=lambda cmd: has_command("python")
        or has_command("python2")
        or has_command("python3"),
    ),
    LangLsp(
        name="R",
        command="R",
        lsp="r_language_server",
    ),
    LangLsp(
        name="ruby",
        command="ruby",
        lsp=["ruby_ls", "solargraph"],
        nullls=["rubocop", "standardrb", "erb_lint"],
    ),
    LangLsp(
        name="rust",
        command=["rustc", "cargo"],
        lsp="rust_analyzer",
    ),
    LangLsp(
        name="sql",
        command=["mysql", "psql", "sqlplus"],  # mysql/postgresql/oracle
        lsp=["sqlls", "sqls"],
        nullls=["sqlfluff", "sql_formatter"],
        checker=lambda cmd: has_command("mysql")
        or has_command("psql")
        or has_command("sqlplus"),
    ),
    LangLsp(
        name="sh",
        command="sh",
        nullls=["shellcheck", "shellharden", "shfmt"],
    ),
    LangLsp(
        name="solidity",
        command=["solc", "solcjs"],
        lsp=["solang", "solc", "solidity"],
        nullls="solhint",
        checker=lambda cmd: has_command("solc") or has_command("solcjs"),
    ),
    LangLsp(
        name="toml",
        command=["node", "npm"],
        lsp="taplo",
        nullls="taplo",
    ),
    LangLsp(
        name="vim",
        command="vim",
        lsp="vimls",
        nullls="vint",
        checker=lambda cmd: True,  # vim is embeded
    ),
    LangLsp(
        name="xml",
        command=["node", "npm"],
        lsp="lemminx",
    ),
    LangLsp(
        name="yaml",
        command=["node", "npm"],
        lsp="yamlls",
        nullls=["actionlint", "yamlfmt", "yamllint", "cfn_lint"],
    ),
]


# Lsp }


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


# Vim AST }

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


class EmbededServers4Lua(Expr):
    def __init__(self, servers):
        assert isinstance(servers, list)
        self.servers = servers

    def render(self):
        rendered_servers = "\n".join([f"{INDENT}'{s}'," for s in self.servers])
        return (
            """
-- { mason's config
local embeded_servers = {
"""
            + rendered_servers
            + """
}
local embeded_servers_setups = {
    -- default setup
    function(server)
        lspconfig[server].setup({
            on_attach = function(client, bufnr)
                attach_ext(client, bufnr)
            end,
        })
    end,
    -- specific setup
    tsserver = function()
        lspconfig["tsserver"].setup({
            on_attach = function(client, bufnr)
                attach_ext(client, bufnr)
            end,
            root_dir = function(fname)
                -- disable tsserver when detect flow
                return lspconfig.util.root_pattern("tsconfig.json")(fname)
                    or not lspconfig.util.root_pattern(".flowconfig")(fname)
                        and lspconfig.util.root_pattern(
                            "package.json",
                            "jsconfig.json",
                            ".git"
                        )(fname)
            end,
        })
    end,
    -- clangd = function()
    --   require("clangd_extensions").setup({
    --     on_attach = function(client, bufnr)
    --       attach_ext(client, bufnr)
    --     end,
    --   })
    -- end,
    -- ["rust_analyzer"] = function()
    --   require("rust-tools").setup({
    --     on_attach = function(client, bufnr)
    --       attach_ext(client, bufnr)
    --     end,
    --   })
    -- end,
}
-- } mason's config
"""
        )


class EmbededNullls4Lua(Expr):
    def __init__(self, nullls):
        assert isinstance(nullls, list)
        self.nullls = nullls

    def render(self):
        rendered_nullls = "\n".join([f"{INDENT}'{n}'," for n in self.nullls])
        return (
            """
-- { null-ls's config
local embeded_nullls = {
"""
            + rendered_nullls
            + """
}
local embeded_nullls_setups = {
    -- default setup
    function(source, methods)
        require("mason-null-ls.automatic_setup")(source, methods)
    end,
    -- specific setup
    -- stylua = function(source, methods)
    --   null_ls.register(null_ls.builtins.formatting.stylua)
    -- end,
}
-- } null-ls's config
"""
        )


# Lua AST }


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


class VeryLazyEventProp(EventProp):
    def __init__(self) -> None:
        super(VeryLazyEventProp, self).__init__("VeryLazy")


class InsertCmdlineEventProp(EventProp):
    def __init__(self) -> None:
        super(InsertCmdlineEventProp, self).__init__("InsertEnter", "CmdlineEnter")


class InsertEventProp(EventProp):
    def __init__(self) -> None:
        super(InsertEventProp, self).__init__("InsertEnter")


class VimEnterEventProp(EventProp):
    def __init__(self) -> None:
        super(VimEnterEventProp, self).__init__("VimEnter")


class CmdlineEventProp(EventProp):
    def __init__(self) -> None:
        super(CmdlineEventProp, self).__init__("CmdlineEnter")


class BufReadPostEventProp(EventProp):
    def __init__(self) -> None:
        super(BufReadPostEventProp, self).__init__("BufReadPost")


class BufReadPreEventProp(EventProp):
    def __init__(self) -> None:
        super(BufReadPreEventProp, self).__init__("BufReadPre")


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


# Helper Expr }


class Tag(enum.Enum):
    INFRASTRUCTURE = 100
    COLORSCHEME = 200
    HIGHLIGHT = 300
    UI = 400
    SEARCH = 500

    LANGUAGE = 600
    CTAGS = 610
    LSP = 620
    SPECIFIC_LANGUAGE = 630

    EDITING = 700
    KEY_BINDING = 710
    CURSOR_MOTION = 720
    GIT = 730
    EDITING_ENHANCEMENTS = 740


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
        assert isinstance(comments, str) or comments is None
        assert isinstance(color, str) or color is None
        assert isinstance(tag, Tag)
        self.repo = LiteralExpr(repo)  # https://github.com/{org}/{repo}
        self.props = props  # more plugin properties following this line
        self.comments = (
            SmallComment(comments) if isinstance(comments, str) else comments
        )
        self.color = color
        self.tag = tag

    def __str__(self):
        return self.repo.render() if isinstance(self.repo, Expr) else str(self.repo)


PLUGINS = [
    # { Infrastructure and dependencies
    Plugin(
        "nathom/filetype.nvim",
        tag=Tag.INFRASTRUCTURE,
    ),
    Plugin(
        "nvim-lua/plenary.nvim",
        props=Props(LazyProp()),
        tag=Tag.INFRASTRUCTURE,
    ),
    Plugin(
        "neovim/nvim-lspconfig",
        props=Props(LazyProp()),
        tag=Tag.INFRASTRUCTURE,
    ),
    # } Infrastructure and dependencies
    # { Colorscheme
    Plugin(
        "folke/lsp-colors.nvim",
        props=Props(LazyProp()),
        tag=Tag.COLORSCHEME,
    ),
    Plugin(
        "bluz71/vim-nightfly-colors",
        props=ColorProps(),
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
        props=Props(BufReadPostEventProp()),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        "NvChad/nvim-colorizer.lua",
        props=Props(BufReadPostEventProp()),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        "andymass/vim-matchup",
        props=Props(BufReadPostEventProp()),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        "inkarkat/vim-mark",
        props=Props(DependenciesProp("inkarkat/vim-ingo-library"), CmdlineEventProp()),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        "inkarkat/vim-ingo-library",
        props=Props(LazyProp()),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin(
        "haya14busa/is.vim",
        props=Props(BufReadPostEventProp()),
        tag=Tag.HIGHLIGHT,
    ),
    Plugin("markonm/traces.vim", props=Props(CmdlineEventProp()), tag=Tag.HIGHLIGHT),
    # } Highlight
    # { UI
    Plugin(
        "nvim-tree/nvim-tree.lua",
        props=Props(
            VeryLazyEventProp(), DependenciesProp("nvim-tree/nvim-web-devicons")
        ),
        comments="File explorer",
        tag=Tag.UI,
    ),
    # Plugin(
    #     "nvim-neo-tree/neo-tree.nvim",
    #     props=Props(
    #         BranchProp("v2.x"),
    #         VEventProp(),
    #         DependenciesProp(
    #             "nvim-lua/plenary.nvim",
    #             "nvim-tree/nvim-web-devicons",
    #             "MunifTanjim/nui.nvim",
    #         ),
    #     ),
    #     comments="File explorer",
    #     tag=Tag.UI,
    # ),
    # Plugin(
    #     "MunifTanjim/nui.nvim",
    #     props=Props(LazyProp()),
    #     tag=Tag.UI,
    # ),
    Plugin(
        "nvim-tree/nvim-web-devicons",
        props=Props(LazyProp()),
        tag=Tag.UI,
    ),
    Plugin(
        "akinsho/bufferline.nvim",
        props=Props(
            VersionProp("v3.*"),
            VeryLazyEventProp(),
            DependenciesProp("nvim-tree/nvim-web-devicons", "moll/vim-bbye"),
        ),
        comments="Tabline",
        tag=Tag.UI,
    ),
    Plugin(
        "moll/vim-bbye",
        props=Props(CmdlineEventProp()),
        tag=Tag.UI,
    ),
    Plugin(
        "lukas-reineke/indent-blankline.nvim",
        props=Props(BufReadPostEventProp()),
        comments="Indentline",
        tag=Tag.UI,
    ),
    Plugin(
        "nvim-lualine/lualine.nvim",
        props=Props(
            VeryLazyEventProp(),
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
            VeryLazyEventProp(),
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
        props=Props(BufReadPostEventProp()),
        comments="Git",
        tag=Tag.UI,
    ),
    Plugin(
        "stevearc/dressing.nvim",
        props=Props(VeryLazyEventProp()),
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
        props=Props(CmdlineEventProp(), BuildProp(":call fzf#install()")),
        tag=Tag.SEARCH,
    ),
    Plugin(
        "junegunn/fzf.vim",
        props=Props(CmdlineEventProp(), DependenciesProp("junegunn/fzf")),
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
        props=Props(
            CmdlineEventProp(), DependenciesProp("ludovicchabant/vim-gutentags")
        ),
        comments="Ctags/structure outlines",
        tag=Tag.CTAGS,
    ),
    Plugin(
        "ludovicchabant/vim-gutentags",
        props=Props(VeryLazyEventProp()),
        tag=Tag.CTAGS,
    ),
    Plugin(
        "williamboman/mason.nvim",
        props=Props(VeryLazyEventProp()),
        comments="LSP",
        tag=Tag.LSP,
    ),
    Plugin(
        "williamboman/mason-lspconfig.nvim",
        props=Props(
            VeryLazyEventProp(),
            DependenciesProp(
                "williamboman/mason.nvim",
                "neovim/nvim-lspconfig",
                # "p00f/clangd_extensions.nvim",
            ),
        ),
        tag=Tag.LSP,
    ),
    # Plugin(
    #     "p00f/clangd_extensions.nvim",
    #     props=Props(LazyProp()),
    #     tag=Tag.LSP,
    # ),
    Plugin(
        "jose-elias-alvarez/null-ls.nvim",
        props=Props(VeryLazyEventProp(), DependenciesProp("nvim-lua/plenary.nvim")),
        tag=Tag.LSP,
    ),
    Plugin(
        "jay-babu/mason-null-ls.nvim",
        props=Props(
            VeryLazyEventProp(),
            DependenciesProp(
                "williamboman/mason.nvim", "jose-elias-alvarez/null-ls.nvim"
            ),
        ),
        tag=Tag.LSP,
    ),
    Plugin(
        "hrsh7th/nvim-cmp",
        props=Props(
            InsertCmdlineEventProp(),
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
        tag=Tag.LSP,
    ),
    Plugin(
        "hrsh7th/cmp-nvim-lsp",
        props=Props(InsertCmdlineEventProp()),
        tag=Tag.LSP,
    ),
    Plugin(
        "hrsh7th/cmp-buffer",
        props=Props(InsertCmdlineEventProp()),
        tag=Tag.LSP,
    ),
    Plugin(
        "hrsh7th/cmp-path",
        props=Props(InsertCmdlineEventProp()),
        tag=Tag.LSP,
    ),
    Plugin(
        "hrsh7th/cmp-cmdline",
        props=Props(InsertCmdlineEventProp()),
        tag=Tag.LSP,
    ),
    Plugin(
        "L3MON4D3/LuaSnip",
        props=Props(InsertCmdlineEventProp(), VersionProp("1.*")),
        tag=Tag.LSP,
    ),
    Plugin(
        "saadparwaiz1/cmp_luasnip",
        props=Props(InsertCmdlineEventProp(), DependenciesProp("L3MON4D3/LuaSnip")),
        tag=Tag.LSP,
    ),
    Plugin("DNLHC/glance.nvim", props=Props(BufReadPostEventProp()), tag=Tag.LSP),
    Plugin("onsails/lspkind.nvim", props=Props(LazyProp()), tag=Tag.LSP),
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
        comments="Markdown",
        tag=Tag.SPECIFIC_LANGUAGE,
    ),
    Plugin(
        "justinmk/vim-syntax-extra",
        props=Props(FtProp("lex", "flex", "yacc", "bison")),
        comments="Lex/yacc, flex/bison",
        tag=Tag.SPECIFIC_LANGUAGE,
    ),
    Plugin(
        "rhysd/vim-llvm",
        props=Props(FtProp("llvm", "mir", "mlir", "tablegen")),
        comments="LLVM",
        tag=Tag.SPECIFIC_LANGUAGE,
    ),
    Plugin(
        "zebradil/hive.vim",
        props=Props(FtProp("hive")),
        comments="Hive",
        tag=Tag.SPECIFIC_LANGUAGE,
    ),
    Plugin(
        "slim-template/vim-slim",
        props=Props(FtProp("slim")),
        comments="Slim",
        tag=Tag.SPECIFIC_LANGUAGE,
    ),
    # } Language support
    # { Key binding
    Plugin(
        "folke/which-key.nvim",
        props=Props(InsertCmdlineEventProp(), BufReadPostEventProp()),
        comments="Key mappings",
        tag=Tag.KEY_BINDING,
    ),
    # } Key binding
    # { Motion
    Plugin(
        "phaazon/hop.nvim",
        props=Props(BranchProp("v2"), CmdlineEventProp()),
        tag=Tag.CURSOR_MOTION,
    ),
    Plugin(
        "ggandor/leap.nvim",
        props=Props(BufReadPostEventProp(), DependenciesProp("tpope/vim-repeat")),
        tag=Tag.CURSOR_MOTION,
    ),
    # } Motion
    # { Git
    Plugin(
        "f-person/git-blame.nvim",
        props=Props(CmdlineEventProp()),
        tag=Tag.GIT,
    ),
    Plugin(
        "ruifm/gitlinker.nvim",
        props=Props(CmdlineEventProp(), DependenciesProp("nvim-lua/plenary.nvim")),
        comments="Open In Github/Gitlab/etc",
        tag=Tag.GIT,
    ),
    # } Git
    # { Editing enhancement
    Plugin(
        "windwp/nvim-autopairs",
        props=Props(InsertEventProp()),
        comments="Auto pair/close",
        tag=Tag.EDITING_ENHANCEMENTS,
    ),
    Plugin(
        "alvan/vim-closetag",
        props=Props(InsertEventProp()),
        tag=Tag.EDITING_ENHANCEMENTS,
    ),
    Plugin(
        "numToStr/Comment.nvim",
        props=Props(BufReadPostEventProp()),
        comments="Comment",
        tag=Tag.EDITING_ENHANCEMENTS,
    ),
    Plugin(
        "kkoomen/vim-doge",
        props=Props(
            CmdlineEventProp(),
            # build for non-Windows to avoid error on arm(apple silicon chip)
            BuildProp("npm i --no-save && npm run build:binary:unix")
            if not IS_WINDOWS
            else BuildProp(":call doge#install()"),
        ),
        comments="Generate documents",
        tag=Tag.EDITING_ENHANCEMENTS,
    ),
    Plugin(
        "akinsho/toggleterm.nvim",
        props=Props(VersionProp("*"), CmdlineEventProp()),
        comments="Terminal",
        tag=Tag.EDITING_ENHANCEMENTS,
    ),
    Plugin(
        "mbbill/undotree",
        props=Props(CmdlineEventProp()),
        comments="Undo tree",
        tag=Tag.EDITING_ENHANCEMENTS,
    ),
    Plugin(
        "tpope/vim-repeat",
        props=Props(BufReadPostEventProp()),
        comments="Other",
        tag=Tag.EDITING_ENHANCEMENTS,
    ),
    Plugin(
        "kylechui/nvim-surround",
        props=Props(VersionProp("*"), BufReadPostEventProp()),
        tag=Tag.EDITING_ENHANCEMENTS,
    ),
    Plugin(
        "editorconfig/editorconfig-vim",
        props=Props(BufReadPostEventProp()),
        tag=Tag.EDITING_ENHANCEMENTS,
    ),
    Plugin(
        "axieax/urlview.nvim",
        props=Props(CmdlineEventProp()),
        tag=Tag.EDITING_ENHANCEMENTS,
    ),
    # } Editing enhancement
]


class Render:
    def __init__(
        self,
        use_color,
        no_color,
        no_hilight,
        no_lang,
        no_edit,
        no_plugs,
        no_ctrl_opt,
        with_lsp_opt,
    ):
        self.use_color = use_color
        self.no_color = no_color
        self.no_hilight = no_hilight
        self.no_lang = no_lang
        self.no_edit = no_edit
        self.no_plugs = no_plugs
        self.no_ctrl = no_ctrl_opt
        self.with_lsp_opt = with_lsp_opt

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
        if self.no_lang:
            return stmts
        stmts.append(
            TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/lspservers-header.lua"))
        )

        embeded_servers = []
        embeded_nullls = []
        if self.with_lsp_opt:
            message("")
            message("checking available lsp servers...")
            message("note:")
            message("   1. `ENTER` to accept all")
            message("   2. Numbers separated by comma(e.g 1,2,3...) to select")
            message("   3. `n`/`N` to accept none")
            message("   4. `CTRL-C` to stop extending available lsp servers")
            message("")
            try:
                for ll in LANGUAGE_LSPS:
                    if not ll.checker(ll.command):
                        continue
                    confirmed, ll, nullls = ll.confirm()
                    if not confirmed:
                        continue
                    embeded_servers.extend(ll)
                    embeded_nullls.extend(nullls)
            except KeyboardInterrupt:
                message("stop extending available lsp servers...")
            message("")

        stmts.append(EmbededServers4Lua(dedup_list(embeded_servers)))
        stmts.append(EmbededNullls4Lua(dedup_list(embeded_nullls)))
        stmts.append(
            TemplateContent(pathlib.Path(f"{TEMPLATE_DIR}/lspservers-footer.lua"))
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
                    Stmt(LiteralExpr("NextColor")),
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
        prev_tag = None
        for ctx in PLUGINS:
            assert isinstance(ctx, Plugin)
            # comments
            if ctx.tag != prev_tag:
                plugins.append(BigComment(" ".join(ctx.tag.name.split("_"))))
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
                lua_keys = f"{lua_base}/keys"
                lua_keys_file = f"{NVIM_DIR}/lua/{lua_keys}.lua"

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

                def keys_prop_formatter(lines):
                    return f"keys = {lines}"

                # init
                inits = []
                if pathlib.Path(vim_init_file).exists():
                    inits.append(source_formatter(vim_init))
                if pathlib.Path(lua_init_file).exists():
                    inits.append(require_formatter(lua_init))
                if len(inits) > 0:
                    exp = LiteralExpr(init_function_formatter(inits))
                    if isinstance(props, Props):
                        props.append(exp)
                    else:
                        assert props is None
                        props = Props(exp)
                # config
                configs = []
                if pathlib.Path(vim_config_file).exists():
                    configs.append(source_formatter(vim_config))
                if pathlib.Path(lua_config_file).exists():
                    configs.append(require_formatter(lua_config))
                if len(configs) > 0:
                    exp = LiteralExpr(config_function_formatter(configs))
                    if isinstance(props, Props):
                        props.append(exp)
                    else:
                        assert props is None
                        props = Props(exp)
                # keys
                if pathlib.Path(lua_keys_file).exists():
                    exp = LiteralExpr(keys_prop_formatter(require_formatter(lua_keys)))
                    if isinstance(props, Props):
                        props.append(exp)
                    else:
                        assert props is None
                        props = Props(exp)

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
            # update tag if it's changed
            if prev_tag != ctx.tag:
                prev_tag = ctx.tag
        return plugins, colors

    def is_disabled(self, ctx):
        if self.no_plugs and str(ctx) in self.no_plugs:
            return True
        if self.no_color and ctx.tag == Tag.COLORSCHEME:
            return True
        if self.no_hilight and ctx.tag == Tag.HIGHLIGHT:
            return True
        if self.no_lang and ctx.tag >= Tag.LANGUAGE and ctx.tag < Tag.EDITING:
            return True
        if self.no_edit and ctx.tag >= Tag.EDITING:
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

    @staticmethod
    def lsp(filename):
        with open(filename, "w") as fp:
            for ll in LANGUAGE_LSPS:
                lsp = [ll.lsp] if isinstance(ll.lsp, str) else ll.lsp
                nullls = [ll.nullls] if isinstance(ll.nullls, str) else ll.nullls
                fp.writelines(f"- {ll.name}:\n")
                fp.writelines(
                    f"  - lsp servers: {', '.join(['`' + l + '`' for l in lsp]) if len(lsp) > 0 else 'empty'}\n"
                )
                fp.writelines(
                    f"  - null-ls sources: {', '.join(['`' + n + '`' for n in nullls]) if len(nullls) > 0 else 'empty'}\n"
                )


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
        "--with-lsp",
        dest="with_lsp_opt",
        action="store_true",
        help="with available lsp servers",
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
    parser.add_argument(
        "--dump-lsp",
        dest="dump_lsp_opt",
        action="store_true",
        help="dump lsp server list",
    )
    parser.add_argument(
        "--dump-lsp-file",
        dest="dump_lsp_file_opt",
        default="dump-lsp.md",
        metavar="FILE",
        help="file to dump lsp server list",
    )
    arguments = parser.parse_args()
    return arguments


if __name__ == "__main__":
    arguments = make_arguments()

    if arguments.dump_plugins_opt:
        Dumper.plugins(arguments.dump_plugins_file_opt)
        exit(0)

    if arguments.dump_lsp_opt:
        Dumper.lsp(arguments.dump_lsp_file_opt)
        exit(0)

    if arguments.limit_opt:
        arguments.no_color_opt = True
        arguments.no_hilight_opt = True
        arguments.no_lang_opt = True
        arguments.no_edit_opt = True
        arguments.with_lsp_opt = False
    render = Render(
        arguments.use_color_opt,
        arguments.no_color_opt,
        arguments.no_hilight_opt,
        arguments.no_lang_opt,
        arguments.no_edit_opt,
        arguments.no_plug_opt,
        arguments.no_ctrl_opt,
        arguments.with_lsp_opt,
    )
    plugins, lspservers, colorschemes, settings, init = render.render()
    writer = FileWriter(plugins, lspservers, colorschemes, settings, init)
    writer.write()
