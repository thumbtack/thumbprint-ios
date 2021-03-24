#!/bin/bash

set -e

mkdir -p .github/cache/derived-data-tar-cache
tar cfPp .github/cache/derived-data-tar-cache/derived-data.tar --format=posix .github/cache/derived-data
