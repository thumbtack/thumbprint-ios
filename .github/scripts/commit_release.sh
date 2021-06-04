#!/bin/bash

set -e -o pipefail

git checkout -b "release/$1"

# Update version in podspec.
# (Search podspec for `.version = '1.2.3` and update with new version
# number passed in as script argument).
#
# Regex pattern adapted from
# https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string
# for compatibility with sed.
sed -i "" -E "s/\.version *= *(["'"'"'])(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-(0|[1-9][0-9]]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*)(\.(0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*))*)?(\+[0-9a-zA-Z-]+(\.[0-9a-zA-Z-]+)*)?["'"'"']/.version = \1$1\1/g" Thumbprint.podspec

# Commit changes and push.
git add --all
git commit -m "Release $1"
git push https://$GITHUB_TOKEN@github.com/thumbtack/thumbprint-ios.git head:$(git branch --show-current)
gh pr create --title "Release $1" --body "" --head $(git branch --show-current)
