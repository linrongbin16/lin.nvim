#!/usr/bin/env python3

import os
import sys

args = sys.argv
query = []

i = 1
while i < len(args):
    arg_splits = args[i].split()
    for arg in arg_splits:
        a = arg.strip()
        if len(a) <= 0:
            continue
        query.append(a.upper())
    i += 1

# print(f"args:{args}, query:{query}, iglob:{iglob}")
rg_command = "rg --column -n --no-heading --color=always -S -w -uu"

if len(query) > 0:
    for q in query:
        rg_command += f" {q}"
else:
    rg_command += " ''"

# print(f"rg_command:{rg_command}")
os.system(rg_command)
