#!/bin/bash

set -e -o pipefail

# Search podspec for `.version = '1.2.3` and update with new version
# number passed in as script argument.
sed -i.bak -E "s/\.version *= *(["'"'"'])[0-9]\.[0-9]\.[0-9]["'"'"']/.version = \1$1\1/g" Thumbprint.podspec
rm Thumbprint.podspec.bak

# Install GitHub CLI.
if ! command -v gh &> /dev/null; then
    brew install gh
fi

# Create PR with the podspec change and merge into `main`.
git checkout -b "kb/release-$1"
git add Thumbprint.podspec
git commit -m "Release ${{ github.events.inputs.version }}"
gh pr create --fill
gh pr review --approve
gh pr merge --squash
git checkout main
git pull