#!/bin/bash

set -e -o pipefail

git tag "$1"
git -c core.sshCommand="ssh -i $2" push --tags