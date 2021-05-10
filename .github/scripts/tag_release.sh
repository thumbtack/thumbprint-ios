#!/bin/bash

set -e -o pipefail

git tag "${{ github.event.inputs.version }}"
git push --tags