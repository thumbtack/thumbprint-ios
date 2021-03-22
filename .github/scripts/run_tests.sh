#!/bin/bash

set -e -u -o pipefail

xcodebuild \
    -workspace 'Thumbprint.xcworkspace' \
    -scheme "$scheme" \
    -destination "$destination" \
    clean test | xcpretty