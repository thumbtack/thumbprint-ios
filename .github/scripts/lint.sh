#!/bin/bash

set -e -u -o pipefail

swift build -c release --product swiftformat
./.build/release/swiftformat --lint .

swift build -c release --product swiftlint
./.build/release/swiftlint lint --strict --quiet .
