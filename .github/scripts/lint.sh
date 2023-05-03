#!/bin/bash

set -e -u -o pipefail

# swiflint is executed during the build phase via plugin
# It's not the case with swiftformat which needs to be triggered manually
swift package --allow-writing-to-package-directory swiftformat --lint
