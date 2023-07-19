#!/usr/bin/env python3

import os


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


if __name__ == "__main__":
    ctx = Context()
    config = ctx.init()
    cases = ctx.find_cases(config)
    for case in cases:
        ctx.run_case(case)
