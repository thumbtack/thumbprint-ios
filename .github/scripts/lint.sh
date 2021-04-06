#!/bin/bash

set -e -u -o pipefail

./Pods/SwiftLint/swiftlint lint --strict --quiet --path .
./Pods/SwiftFormat/CommandLineTool/swiftformat --lint .