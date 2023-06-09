#!/bin/bash

set -e -u -o pipefail

swift package -c release swiftformat --lint .
swift package -c release swiftlint lint --strict --quiet --path .
