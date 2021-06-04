#!/bin/bash

set -e -o pipefail

git checkout -b "release/$1"

# Update version in podspec.
# (Search podspec for `.version = '1.2.3` and update with new version
# number passed in as script argument).
sed -i.bak -E "s/\.version *= *(["'"'"'])[0-9](\.[0-9])?(\.[0-9])?["'"'"']/.version = \1$1\1/g" Thumbprint.podspec
rm Thumbprint.podspec.bak

# Commit changes and push.
git add --all
git commit -m "Release $1"
git push https://$GITHUB_TOKEN@github.com/thumbtack/thumbprint-ios.git $(git branch --show-current)
gh pr create --title "Release $1" --body "" --head $(git branch --show-current)
