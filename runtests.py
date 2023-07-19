#!/usr/bin/env python3

import datetime
import logging
import os
import sys

import click


class Config:
    def __init__(
        self, nvim_config_path=f"{os.path.expanduser('~')}/.config/nvim"
    ) -> None:
        self.nvim_config_path = nvim_config_path


class Case:
    pass


class Context:
    def init(self) -> Config:
        return Config()

    def find_cases(self, config: Config) -> list[Case]:
        return []

    def run_case(self, case: Case) -> bool:
        return True

    def report(self) -> None:
        pass


def debug_enabled(args: list[str]):
    return any(
        [
            isinstance(arg, str)
            and (arg.strip().lower() == "-d" or arg.strip().lower() == "--debug")
            for arg in args
        ]
    )


@click.command()
@click.option("-d", "--debug")
def runtests():
    log_level = logging.INFO
    if debug_enabled(sys.argv):
        log_level = logging.DEBUG

    logging.basicConfig(
        filename=f"runtests-{datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S-%f')}.log",
        format="%(asctime)s %(levelname)s [%(funcName)s %(lineno)d]: %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S.%f",
        encoding="utf-8",
        level=log_level,
    )

    ctx = Context()
    config = ctx.init()
    cases = ctx.find_cases(config)
    for case in cases:
        ctx.run_case(case)


if __name__ == "__main__":
    runtests()
