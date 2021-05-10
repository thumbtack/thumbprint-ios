#!/bin/bash

set -e -o pipefail

# Search podspec for `.version = '1.2.3` and update with new version
# number passed in as script argument.
sed -i.bak -E "s/\.version *= *(["'"'"'])[0-9]\.[0-9]\.[0-9]["'"'"']/.version = \1$1\1/g" Thumbprint.podspec
rm Thumbprint.podspec.bak
