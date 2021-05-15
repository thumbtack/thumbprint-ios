#!/bin/bash

set -e -o pipefail

git tag "${{ github.event.inputs.version }}"
git -c core.sshCommand="ssh -i $1" push --tags