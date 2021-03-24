#!/bin/bash

set -e -u -o pipefail

xcodebuild \
    -IgnoreFileSystemDeviceInodeChanges=1 \
    -derivedDataPath .github/cache/derived-data \
    -workspace 'Thumbprint.xcworkspace' \
    -scheme "$scheme" \
    -destination "$destination" \
    clean test

