#!/bin/bash

for f in $(git ls-tree -r -t --full-name --name-only head); do
    # Set file's last modified time to the time of the last commit that modified it.
    touch -t $(git log --pretty=format:%cd --date=format:%Y%m%d%H%M.%S -1 "head" -- "$f") "$f"
done
