#!/bin/bash

BUILD_VERSION=$(git describe --tags)
BUILD_DATE=$(date -u '+%Y/%m/%d-%H:%M:%S')

echo building $BUILD_VERSION $BUILD_DATE
gox -ldflags "-X main.version=$BUILD_VERSION -X main.buildDate=$BUILD_DATE" -output "dist/ncd_{{.OS}}_{{.Arch}}"

if [[ -s dist/ncd_darwin_amd64 ]]; then
  binary_shasum=$(shasum -a 256 <dist/ncd_darwin_amd64 | awk '{print $1}')
  source_shasum=$(curl -sSL https://github.com/turnerlabs/harbor-compose/archive/$BUILD_VERSION.tar.gz | shasum -a 256 | awk '{print $1}')
  erb  version="${BUILD_VERSION#v}" "source_shasum=$source_shasum" "binary_shasum=$binary_shasum" harbor-compose.erb >harbor-compose.rb
fi
