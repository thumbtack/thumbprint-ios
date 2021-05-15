#!/bin/bash

set -e -o pipefail

git -c core.sshCommand="ssh -i $2" remote update
git -c core.sshCommand="ssh -i $2" fetch
git -c core.sshCommand="ssh -i $2" checkout --track origin/main
git add --all
git commit -m "Release $1"
git -c core.sshCommand="ssh- i $2" push origin main