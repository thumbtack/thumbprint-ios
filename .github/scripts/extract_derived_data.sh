#!/bin/bash

set -e

if [ -f .github/cache/derived-data-tar-cache/derived-data.tar ]; then
    tar xvPpf .github/cache/derived-data-tar-cache/derived-data.tar
else
    echo "No existing Derived Data cache found"
fi
