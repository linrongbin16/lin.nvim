#!/usr/bin/env python3

import os
import platform
import sys

IS_WINDOWS = platform.system().find("Windows") >= 0
args = sys.argv
branch = ""

i = 1
while i < len(args):
    branch += f" {args[i]}"
    i += 1

branch = branch.strip()
if branch.startswith("*"):
    branch = branch[1:]
right_arrow = branch.find("->")
if right_arrow >= 0:
    branch = branch[right_arrow + 2 :].strip()

# with open("fzf_git_branches_preview.log", "a") as fp:
#     fp.writelines(f"args:{args}, branch:{branch}\n")
git_log_command = f"git log --graph --pretty=oneline --abbrev-commit --color {branch}"

# with open("fzf_git_branches_preview.log", "a") as fp:
#     fp.writelines(f"git_log_command:{git_log_command}\n")
os.system(git_log_command)
