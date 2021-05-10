#!/bin/bash

set -e -o pipefail

git remote update
git fetch
git checkout --track origin/main
git add --all
git commit -m "Release $1"
git push origin main