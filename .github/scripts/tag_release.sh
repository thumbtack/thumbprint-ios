#!/bin/bash

set -e -o pipefail

git tag "$1"
git push --tags https://$GITHUB_TOKEN@github.com/thumbtack/thumbprint-ios.git
