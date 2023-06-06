#!/usr/bin/env python3

import os
import sys
import platform

IS_WINDOWS = platform.system().find('Windows') >= 0
args = sys.argv
query = []
iglob = []
iglob_start = False

i = 1
while i < len(args):
    arg_splits = args[i].split()
    for arg in arg_splits:
        a = arg.strip()
        if len(a) <= 0:
            continue
        if a == "--":
            iglob_start = True
            continue
        if iglob_start:
            iglob.append(a)
        else:
            query.append(a)
    i += 1

# print(f"args:{args}, query:{query}, iglob:{iglob}")
rg_command = "rg --column -n --no-heading --color=always -S"

if len(iglob) > 0:
    for ig in iglob:
        rg_command += f" --iglob {ig}"

if len(query) > 0:
    for q in query:
        rg_command += f" {q}"
else:
    if not IS_WINDOWS:
        rg_command += " ''"

# print(f"[fzf_live_grep] rg_command:{rg_command}")
os.system(rg_command)
