#!/bin/bash

set -e -u -o pipefail

xcodebuild \
    -scheme "$scheme" \
    -destination "$destination" \
    -skipPackagePluginValidation \
    clean test

