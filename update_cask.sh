#!/usr/bin/env bash

set -xueo pipefail

releases_info=$(curl \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: ${GITHUB_TOKEN}" https://api.github.com/repos/otto-de/logsmith/releases)

echo "$releases_info" | jq .

# Filter out releases where .name contains "-yanked" or "prerelease" is true, get the latest one
release_info=$(echo "$releases_info" | jq -c '[.[] | select((.name | contains("-yanked") | not) and (.prerelease | not))] | first')
prerelease_info=$(echo "$releases_info" | jq -c '[.[] | select((.name | contains("-yanked") | not) and (.prerelease))] | first')

version=$(echo "$release_info" | jq -r .name)
url=$(echo "$release_info" | jq -r '.assets | .[] | .browser_download_url' | grep darwin)

prerelease_version=$(echo "$prerelease_info" | jq -r .name)
prerelease_url=$(echo "$prerelease_info" | jq -r '.assets | .[] | .browser_download_url' | grep darwin)

rm -f ./release.zip &
curl -L -o release.zip "${url}"
checksum=$(sha256sum release.zip | cut -d " " -f 1)

rm -f ./prerelease.zip &
curl -L -o prerelease.zip "${prerelease_url}"
prerelease_checksum=$(sha256sum prerelease.zip | cut -d " " -f 1)

echo "cask \"logsmith\" do
  version \"${version}\"
  homepage \"ttps://github.com/otto-de/logsmith\"
  sha256 \"${checksum}\"
  url \"https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip\"
  app \"dist/logsmith.app\"
end" > ./Casks/logsmith.rb

echo "cask \"logsmith-beta\" do
  version \"${prerelease_version}\"
  homepage \"https://github.com/otto-de/logsmith\"
  sha256 \"${prerelease_checksum}\"
  url \"https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip\"
  app \"dist/logsmith.app\"
end" > ./Casks/logsmith-beta.rb
