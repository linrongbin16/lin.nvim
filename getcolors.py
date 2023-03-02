#!/usr/bin/env python3

import datetime
import logging
import sys
import typing

from selenium.webdriver import Chrome, ChromeOptions, DesiredCapabilities
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions
from selenium.webdriver.support.ui import WebDriverWait

STARS = 400
LASTCOMMIT = 2 * 365 * 24 * 3600  # 2 years * 365 days * 24 hours * 3600 seconds
INDENT_SIZE = 4
INDENT = " " * INDENT_SIZE
HEADLESS = False


def parse_numbers(s):
    def impl(v):
        assert isinstance(v, str)
        v = v.lower()
        suffix_map = {"k": 1000, "m": 1000000, "b": 1000000000}
        if v[-1] in suffix_map.keys():
            suffix = v[-1]
            v = float(v[:-1]) * suffix_map[suffix]
        else:
            v = float(v)
        return v

    i = 0
    result = None
    while i < len(s):
        c = s[i]
        assert isinstance(c, str)
        i += 1
        if c.isdigit() or c == "." or c.lower() in ["k", "m", "b"]:
            if result is None:
                result = c
            else:
                result = result + c
        else:
            if result is None:
                continue
            else:
                return impl(result)
    assert False


def repo_exist(repos, r):
    for repo in repos:
        logging.debug(f"repo({repo}) == r({r}):{repo == r}")
        if r == repo:
            return True
    return False


def duplicate_color(repos, r):
    def position(url):
        assert isinstance(url, str)
        if url.endswith(".vim"):
            return url.find(".vim")
        if url.endswith(".nvim"):
            return url.find(".nvim")
        if url.endswith("-vim"):
            return url.find("-vim")
        if url.endswith("-nvim"):
            return url.find("-nvim")
        return -1

    def same(r1, r2):
        r1 = r1.url.split("/")[-1]
        r2 = r2.url.split("/")[-1]
        if r1 == r2 and (
            r1 != "vim"
            and r1 != "nvim"
            and r1 != "neovim"
            and r2 != "vim"
            and r2 != "nvim"
            and r2 != "neovim"
        ):
            return True
        pos1 = position(r1)
        pos2 = position(r2)
        if pos1 <= 0 or pos2 <= 0:
            return False
        base1 = r1[:pos1]
        base2 = r2[:pos2]
        return base1 == base2

    for repo in repos:
        if same(repo, r):
            return repo
    return None


def blacklist(repo):
    if repo.url.find("rafi/awesome-vim-colorschemes") >= 0:
        return True
    if repo.url.find("sonph/onehalf") >= 0:
        return True
    if repo.url.find("mini.nvim#minischeme") >= 0:
        return True
    return False


def find_element(driver, xpath):
    WebDriverWait(driver, 30).until(
        expected_conditions.presence_of_element_located((By.XPATH, xpath))
    )
    return driver.find_element(By.XPATH, xpath)


def find_elements(driver, xpath):
    WebDriverWait(driver, 30).until(
        expected_conditions.presence_of_element_located((By.XPATH, xpath))
    )
    return driver.find_elements(By.XPATH, xpath)


def make_driver():
    options = ChromeOptions()
    if HEADLESS:
        options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--single-process")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--allow-running-insecure-content")
    options.add_argument("--ignore-certificate-errors")
    options.add_argument("--allow-insecure-localhost")
    options.add_argument("--disable-blink-features=AutomationControlled")
    options.add_experimental_option("useAutomationExtension", False)
    options.add_experimental_option("excludeSwitches", ["enable-automation"])

    desired_capabilities = DesiredCapabilities().CHROME.copy()
    # desired_capabilities["pageLoadStrategy"] = "eager"
    desired_capabilities["acceptInsecureCerts"] = True

    return Chrome(options=options, desired_capabilities=desired_capabilities)


class PluginData:
    def __init__(self, url, stars, last_update):
        assert isinstance(url, str)
        assert isinstance(stars, int) or isinstance(stars, float)
        assert isinstance(last_update, datetime.datetime) or last_update is None
        url = url.strip()
        while url.startswith("/"):
            url = url[1:]
        while url.endswith("/"):
            url = url[:-1]
        self.url = url
        self.stars = int(stars)
        self.last_update = last_update
        self.branch = self._get_branch()
        self.colorscheme_names = self._get_colorscheme_names(self.branch)

    def __str__(self):
        return f"<PluginData url:{self.url}, stars:{self.stars}, last_update:{self.last_update.isoformat() if isinstance(self.last_update, datetime.datetime) else None}>"

    def __hash__(self):
        return hash(self.url.lower())

    def __eq__(self, other):
        return isinstance(other, PluginData) and self.url.lower() == other.url.lower()

    def github_url(self):
        return f"https://github.com/{self.url}"

    def _get_branch(self):
        with make_driver() as driver:
            driver.get(self.github_url() + "/branches")
            branches = find_elements(driver, "//branch-filter-item")
            for b in branches:
                if b.get_attribute("branch") == "main":
                    return "main"
        return "master"

    def _get_colorscheme_names(self, branch):
        names = []
        with make_driver() as driver:
            driver.get(self.github_url() + f"/tree/{branch}/colors")
            files = find_elements(driver, "//tr[@class='react-directory-row']")
            for f in files:
                filename_td = f.find_elements(By.XPATH, "./td")[0]
                filetype = filename_td.find_element(By.XPATH, "./div/div/div").text
                if filetype.lower().find("file") < 0:
                    continue
                filename = filename_td.find_element(By.XPATH, "./div/div/h3").text
                if filename.endswith(".vim") or filename.endswith(".lua"):
                    names.append(filename[:4])
        return names

    def lazy_branch(self):
        return f"branch = '{self.branch}'" if self.branch != "master" else None


class Vcs:
    def pages(self):
        i = 0
        while True:
            if i == 0:
                yield "https://vimcolorschemes.com/top"
            else:
                yield f"https://vimcolorschemes.com/top/page/{i+1}"
            i += 1

    def parse_repo(self, element):
        repo = "/".join(
            element.find_element(By.XPATH, "./a[@class='card__link']")
            .get_attribute("href")
            .split("/")[-2:]
        )
        stars = int(
            element.find_element(
                By.XPATH,
                "./a/section/header[@class='meta-header']//div[@class='meta-header__statistic']//b",
            ).text
        )
        creates_updates = element.find_elements(
            By.XPATH,
            "./a/section/footer[@class='meta-footer']//div[@class='meta-footer__column']//p[@class='meta-footer__row']",
        )
        last_update = datetime.datetime.fromisoformat(
            creates_updates[1]
            .find_element(By.XPATH, "./b/time")
            .get_attribute("datetime")
        )

        return PluginData(repo, stars, last_update)

    def parse(self):
        repositories = []
        with make_driver() as driver:
            for page_url in self.pages():
                driver.get(page_url)
                any_valid_stars = False
                for element in find_elements(driver, "//article[@class='card']"):
                    repo = self.parse_repo(element)
                    logging.debug(f"vsc repo:{repo}")
                    if repo.stars < STARS:
                        logging.debug(f"vsc skip for stars - repo:{repo}")
                        continue
                    assert isinstance(repo.last_update, datetime.datetime)
                    if (
                        repo.last_update.timestamp() + LASTCOMMIT
                        < datetime.datetime.now().timestamp()
                    ):
                        logging.debug(f"vsc skip for last_update - repo:{repo}")
                        continue
                    logging.debug(f"vsc get - repo:{repo}")
                    repositories.append(repo)
                    any_valid_stars = True
                if not any_valid_stars:
                    logging.debug(f"vsc no valid stars, exit")
                    break
            return repositories


class Acs:
    def parse_repo(self, element):
        a = element.find_element(By.XPATH, "./a").text
        a_splits = a.split("(")
        repo = a_splits[0]
        stars = parse_numbers(a_splits[1])
        return PluginData(repo, stars, None)

    def parse_color(self, driver, tag_id):
        repositories = []
        colors_group = find_element(
            driver,
            f"//main[@class='markdown-body']/h4[@id='{tag_id}']/following-sibling::ul",
        )
        for e in colors_group.find_elements(By.XPATH, "./li"):
            repo = self.parse_repo(e)
            logging.debug(f"acs repo:{repo}")
            repositories.append(repo)
        return repositories

    def parse(self):
        repositories = []
        with make_driver() as driver:
            driver.get(
                "https://www.trackawesomelist.com/rockerBOO/awesome-neovim/readme"
            )
            treesitter_colors = self.parse_color(
                driver, "tree-sitter-supported-colorscheme"
            )
            lua_colors = self.parse_color(driver, "lua-colorscheme")
            treesitter_colors.extend(lua_colors)
            for repo in treesitter_colors:
                if repo.stars < STARS:
                    logging.debug(f"asc skip for stars - repo:{repo}")
                    continue
                logging.debug(f"acs get - repo:{repo}")
                repositories.append(repo)
        return repositories


def format_lazy(repo, duplicated_repo):
    optional_branch = (
        (INDENT * 2 + repo.lazy_branch() + "\n") if repo.lazy_branch() else ""
    )
    return f"""{INDENT}{{
{INDENT*2}-- stars:{int(repo.stars)}
{INDENT*2}-- repo:{repo.github_url()}, {' (duplicated with repo:' + duplicated_repo.github_url() + ')' if duplicated_repo else ''}
{INDENT*2}-- colorscheme names:{' '.join(repo.colorscheme_names)}
{INDENT*2}'{repo.url}',
{INDENT*2}lazy = true,
{INDENT*2}priority = 1000,
{optional_branch}{INDENT}}},
"""


if __name__ == "__main__":
    logging.basicConfig(
        format="%(asctime)s %(levelname)s [%(filename)s:%(lineno)d](%(funcName)s) %(message)s",
        level=logging.DEBUG if "--debug" in sys.argv else logging.INFO,
    )

    vcs = Vcs().parse()
    acs = Acs().parse()
    cs = []
    with open("get-colors-list.lua", "w") as fp:
        fp.writelines("return {\n")
        fp.writelines(
            f"{INDENT}-- https://www.trackawesomelist.com/rockerBOO/awesome-neovim/readme/#colorscheme\n"
        )
        for repo in sorted(acs, key=lambda r: r.stars, reverse=True):
            if blacklist(repo):
                logging.debug("acs repo:{repo} in blacklist, skip")
            dup = duplicate_color(cs, repo)
            fp.writelines(format_lazy(repo, dup))
            cs.append(repo)
        fp.writelines(f"\n{INDENT}-- https://vimcolorschemes.com/\n")
        for repo in sorted(vcs, key=lambda r: r.stars, reverse=True):
            if repo_exist(acs, repo):
                logging.debug("vcs repo:{repo} already exist in acs, skip")
            elif blacklist(repo):
                logging.debug("vcs repo:{repo} in blacklist, skip")
            else:
                dup = duplicate_color(cs, repo)
                fp.writelines(format_lazy(repo, dup))
                cs.append(repo)
        fp.writelines("}\n")
