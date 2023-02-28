#!/usr/bin/env python3

import argparse
import datetime
import pathlib
import platform
import shutil
from collections import OrderedDict

HOME_DIR = pathlib.Path.home()
NVIM_DIR = pathlib.Path(f"{HOME_DIR}/.nvim")
TEMPLATE_DIR = pathlib.Path(f"{NVIM_DIR}/temp")

IS_WINDOWS = platform.system().lower().startswith("win")
IS_MACOS = platform.system().lower().startswith("darwin")
INDENT_SIZE = 4
INDENT = " " * INDENT_SIZE

# Util {


def format_message(*args):
    """format message"""
    return f"[lin.nvim] - {' '.join(args)}"


def message(*args):
    """message"""
    print(format_message(*[a for a in args]))


def error_message(*args):
    """error message"""
    print(f"[lin.nvim] - error! {' '.join(args)}")


def try_backup(src):
    """backup file"""
    assert isinstance(src, pathlib.Path)
    if src.is_symlink() or src.exists():
        dest = f"{src}.{datetime.datetime.now().strftime('%Y-%m-%d.%H-%M-%S.%f')}"
        src.rename(dest)
        message(f"backup '{src}' to '{dest}'")


def dedup_list(l):
    """dedup items in list"""
    return list(OrderedDict.fromkeys(l))


def has_command(cmd):
    """detect command exist"""
    return shutil.which(cmd) is not None


# Util }

# Lsp {


class Lsp:
    """Lsp data"""

    def __init__(self, name=None, command=None, server=None, nullls=None, checker=None):
        assert isinstance(name, str)
        assert isinstance(command, str) or isinstance(command, list)
        assert isinstance(server, str) or isinstance(server, list) or server is None
        assert isinstance(nullls, str) or isinstance(nullls, list) or nullls is None
        self.name = name
        self.command = [command] if isinstance(command, str) else command
        if server is None:
            server = []
        if nullls is None:
            nullls = []
        self.server = [server] if isinstance(server, str) else server
        self.nullls = [nullls] if isinstance(nullls, str) else nullls
        if checker:
            self.checker = checker
        else:
            self.checker = lambda cmd: all([has_command(c) for c in cmd])

    def confirm(self):
        recommends = dedup_list(self.server + self.nullls)
        candidates = ", ".join([f"{i+1}:{r}" for i, r in enumerate(recommends)])
        message("")
        result = input(
            format_message(
                f"detect '{self.name}' (by {'/'.join(self.command)}), install lsp({candidates})? "
            )
        )

        lsp_servers = []
        nullls_sources = []

        def add_candidate(c):
            if c in self.server:
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


# https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
# https://github.com/jay-babu/mason-null-ls.nvim#available-null-ls-sources
LANGUAGES = [
    Lsp(
        name="assembly",
        command=["as", "rustc", "cargo"],
        server="asm_lsp",
    ),
    Lsp(
        name="bash",
        command="bash",
        server="bashls",
    ),
    Lsp(
        name="c/c++",
        command=["gcc", "g++", "clang", "clang++", "MSBuild", "cl"],
        server="clangd",
        nullls=["cpplint", "clang_format"],
        checker=lambda cmd: (has_command("gcc") and has_command("g++"))
        or (has_command("clang") and has_command("clang++"))
        or (has_command("MSBuild") and has_command("cl")),
    ),
    Lsp(
        name="clojure",
        command="clj",
        server="clojure_lsp",
        nullls="joker",
    ),
    Lsp(
        name="cmake",
        command="cmake",
        server=["cmake", "neocmake"],
    ),
    Lsp(
        name="crystal",
        command="crystal",
        server="crystalline",
    ),
    Lsp(
        name="csharp",
        command=["csc", "dotnet", "mcs"],
        server=["csharp_ls", "omnisharp_mono", "omnisharp"],
        nullls=["csharpier", "clang_format"],
        checker=lambda cmd: has_command("csc")
        or has_command("dotnet")
        or has_command("mcs"),
    ),
    Lsp(
        name="css",
        command=["node", "npm"],
        server=["cssls", "cssmodules_ls", "unocss"],
    ),
    Lsp(
        name="docker",
        command="docker",
        server="dockerls",
        nullls="hadolint",
    ),
    Lsp(
        name="dot(graphviz)",
        command="dot",
        server="dotls",
    ),
    Lsp(
        name="elixir",
        command="elixir",
        server="elixirls",
    ),
    Lsp(
        name="erlang",
        command="erl",
        server="erlangls",
    ),
    Lsp(
        name="fortran",
        command="gfortran",
        server="fortls",
    ),
    Lsp(
        name="fsharp",
        command="dotnet",
        server="fsautocomplete",
    ),
    Lsp(
        name="go",
        command="go",
        server=["golangci_lint_ls", "gopls"],
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
    Lsp(
        name="groovy",
        command="groovy",
        server="groovyls",
    ),
    Lsp(
        name="haskell",
        command="ghc",
        server="hls",
    ),
    Lsp(
        name="html",
        command=["node", "npm"],
        server="html",
        nullls="curlylint",
    ),
    Lsp(
        name="java",
        command=["javac", "java"],
        server="jdtls",
        nullls="clang_format",
    ),
    Lsp(
        name="javascript/typescript",
        command=["node", "npm"],
        server=["quick_lint_js", "tsserver", "vtsls", "eslint"],
        nullls=["rome", "xo", "eslint_d", "prettier", "prettierd"],
    ),
    Lsp(
        name="json",
        command=["node", "npm"],
        server="jsonls",
        nullls=["fixjson", "jq", "cfn_lint"],
    ),
    Lsp(
        name="julia",
        command="julia",
        server="julials",
        nullls=["fixjson", "jq"],
    ),
    Lsp(
        name="kotlin",
        command="kotlinc",
        server="kotlin_language_server",
        nullls="ktlint",
    ),
    Lsp(
        name="latex",
        command=["latex", "pdflatex", "xelatex"],
        server=["ltex", "texlab"],
        nullls=["proselint", "vale"],
        checker=lambda cmd: has_command("latex")
        or has_command("pdflatex")
        or has_command("xelatex"),
    ),
    Lsp(
        name="lua",
        command="lua",
        server=["lua_ls"],
        nullls=["selene", "stylua"],
        checker=lambda cmd: True,  # lua is embeded
    ),
    Lsp(
        name="luarocks",
        command=["lua", "luarocks"],
        nullls="luacheck",
    ),
    Lsp(
        name="markdown",
        command=["node", "npm"],
        server=["marksman", "prosemd_lsp", "remark_ls", "zk"],
        nullls=["alex", "markdownlint", "write_good", "cbfmt", "proselint", "vale"],
    ),
    Lsp(
        name="ocaml",
        command="ocaml",
        server=["ocamllsp"],
    ),
    Lsp(
        name="perl",
        command="perl",
        server=["perlnavigator"],
    ),
    Lsp(
        name="php",
        command="php",
        server=["intelephense", "phpactor", "psalm"],
        nullls=["phpcbf", "psalm"],
    ),
    Lsp(
        name="powershell",
        command=["pwsh", "powershell"],
        server=["powershell_es"],
        checker=lambda cmd: has_command("pwsh") or has_command("powershell"),
    ),
    Lsp(
        name="protobuf",
        command="protoc",
        server=["bufls"],
        nullls=["buf", "protolint"],
    ),
    Lsp(
        name="python",
        command=["python", "python2", "python3"],
        server=[
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
    Lsp(
        name="R",
        command="R",
        server="r_language_server",
    ),
    Lsp(
        name="ruby",
        command="ruby",
        server=["ruby_ls", "solargraph"],
        nullls=["rubocop", "standardrb", "erb_lint"],
    ),
    Lsp(
        name="rust",
        command=["rustc", "cargo"],
        server="rust_analyzer",
    ),
    Lsp(
        name="sql",
        command=["mysql", "psql", "sqlplus"],  # mysql/postgresql/oracle
        server=["sqlls", "sqls"],
        nullls=["sqlfluff", "sql_formatter"],
        checker=lambda cmd: has_command("mysql")
        or has_command("psql")
        or has_command("sqlplus"),
    ),
    Lsp(
        name="sh",
        command="sh",
        nullls=["shellcheck", "shellharden", "shfmt"],
    ),
    Lsp(
        name="solidity",
        command=["solc", "solcjs"],
        server=["solang", "solc", "solidity"],
        nullls="solhint",
        checker=lambda cmd: has_command("solc") or has_command("solcjs"),
    ),
    Lsp(
        name="toml",
        command=["node", "npm"],
        server="taplo",
        nullls="taplo",
    ),
    Lsp(
        name="vim",
        command="vim",
        server="vimls",
        nullls="vint",
        checker=lambda cmd: True,  # vim is embeded
    ),
    Lsp(
        name="xml",
        command=["node", "npm"],
        server="lemminx",
    ),
    Lsp(
        name="yaml",
        command=["node", "npm"],
        server="yamlls",
        nullls=["actionlint", "yamlfmt", "yamllint", "cfn_lint"],
    ),
]


# Lsp }


class LspServers:
    # Template {

    TEMP1 = """
-- { ---- Add new LSP server ----
--
-- Case-1: Add LSP server name in 'embeded_servers'.
--  LSP server is working as nvim-cmp sources, installed by mason-lspconfig.
--  Please refer to:
--      * [mason-lspconfig Available LSP servers](https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers) for more LSP servers.
--      * [nvim-lspconfig's language specific plugins](https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins) for more specific language plugins.
--
-- Case-2: Add extra null-ls source in 'embeded_extras'.
--  Extra null-ls source is working as null-ls sources, installed by mason-null-ls.
--  Please refer to:
--      * [mason-null-ls Available Null-ls sources](https://github.com/jay-babu/mason-null-ls.nvim#available-null-ls-sources) for more null-ls sources.
--      * [null-ls BUILTINS](https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md) for null-ls source configurations.

local null_ls = require("null-ls")
local lspconfig = require("lspconfig")

local function attach_ext(client, bufnr)
    -- attach navic to work with multiple tabs
    if client.server_capabilities["documentSymbolProvider"] then
        require("nvim-navic").attach(client, bufnr)
    end
end


-- { mason's config
local embeded_servers = {
"""

    TEMP2 = """
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

-- { null-ls's config
local embeded_nullls = {
"""

    TEMP3 = """
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

-- { lspconfig's setup

local embeded_lspconfig_setups = {
    ["flow"] = {
        on_attach = function(client, bufnr)
            attach_ext(client, bufnr)
        end,
    },
}

-- } lspconfig's setup

-- }

-- { ---- The real config work goes here ----

-- Setup mason-lspconfig
require("mason-lspconfig").setup({ ensure_installed = embeded_servers })
require("mason-lspconfig").setup_handlers(embeded_servers_setups)

-- Setup mason-null-ls and null-ls configs
require("mason-null-ls").setup({ ensure_installed = embeded_nullls })
require("mason-null-ls").setup_handlers(embeded_nullls_setups)
null_ls.setup()

-- Lspconfig setups
for name, cfg in pairs(embeded_lspconfig_setups) do
    lspconfig[name].setup(cfg)
end

-- }
"""
    # Template }

    def __init__(
        self, with_lsp_opt, target=f"{NVIM_DIR}/lua/cfg/lspservers.lua"
    ) -> None:
        self.with_lsp_opt = with_lsp_opt
        self.target = target

    def generate(self):
        content = self.render()
        pathlib.Path(f"{NVIM_DIR}/lua").mkdir(parents=True, exist_ok=True)
        try_backup(pathlib.Path(self.target))
        with open(self.target, "w") as fp:
            fp.write(content)

    def render(self):
        statements = []
        statements.append(LspServers.TEMP1)

        embeded_servers = []
        embeded_nullls = []

        if self.with_lsp_opt:
            message("")
            message("checking available lsp servers...")
            message("operation:")
            message("   1. Use `ENTER` to accept all")
            message("   2. Use numbers(e.g. 1,2,3...) to select")
            message("   3. Use `N` to accept none")
            message("   4. Use `CTRL-C` to stop extending available lsp servers")
            try:
                for lang in LANGUAGES:
                    if not lang.checker(lang.command):
                        continue
                    confirmed, lang, nullls = lang.confirm()
                    if not confirmed:
                        continue
                    embeded_servers.extend(lang)
                    embeded_nullls.extend(nullls)
            except KeyboardInterrupt:
                message("stop extending available lsp servers...")

        embeded_servers = "\n".join(
            [f"{INDENT}'{e}'," for e in dedup_list(embeded_servers)]
        )
        embeded_nullls = "\n".join(
            [f"{INDENT}'{e}'," for e in dedup_list(embeded_nullls)]
        )

        statements.extend(embeded_servers)
        statements.append(LspServers.TEMP2)
        statements.extend(embeded_nullls)
        statements.append(LspServers.TEMP3)

        return "".join(statements)


class LanguageList:
    @staticmethod
    def dump(filename):
        with open(filename, "w") as fp:
            for lang in LANGUAGES:
                lsp = [lang.server] if isinstance(lang.server, str) else lang.server
                nullls = [lang.nullls] if isinstance(lang.nullls, str) else lang.nullls
                fp.writelines(f"- {lang.name}:\n")
                fp.writelines(
                    f"  - lsp servers: {', '.join(['`' + l + '`' for l in lsp]) if len(lsp) > 0 else 'empty'}\n"
                )
                fp.writelines(
                    f"  - null-ls sources: {', '.join(['`' + n + '`' for n in nullls]) if len(nullls) > 0 else 'empty'}\n"
                )


def make_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--with-lsp",
        dest="with_lsp_opt",
        action="store_true",
        help="with available lsp servers",
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
        default="lsp-server-list.md",
        metavar="FILE",
        help="file to dump lsp server list",
    )
    return parser.parse_args()


if __name__ == "__main__":
    arguments = make_arguments()

    if arguments.dump_lsp_opt:
        LanguageList.dump(arguments.dump_lsp_file_opt)
        exit(0)

    lspservers = LspServers(arguments.with_lsp_opt)
    lspservers.generate()
