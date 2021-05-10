#!/bin/bash

set -e -o pipefail

git tag "$1"
git push --tags
