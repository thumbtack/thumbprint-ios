#!/bin/bash

set -e -u -o pipefail

swift package plugin --allow-writing-to-package-directory swiftlint lint --strict --quiet --path .
swift package plugin --allow-writing-to-package-directory swiftformat --lint .
