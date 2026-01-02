#!/usr/bin/env bash

set -xueo pipefail

releases_info=$(curl \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: ${GITHUB_TOKEN}" https://api.github.com/repos/otto-de/logsmith/releases)

echo "$releases_info" | jq .

# Filter out releases where .name contains "-yanked" or "prerelease" is true, get the latest one
release_info=$(echo "$releases_info" | jq -c '[.[] | select((.name | contains("-yanked") | not) and (.prerelease | not))] | first')
prerelease_info=$(echo "$releases_info" | jq -c '[.[] | select((.name | contains("-yanked") | not) and (.prerelease))] | first')
major_releases=$(python3 - <<'PY'
import json, sys

data = json.load(sys.stdin)
majors = {}
ordered = []
for r in data:
    name = r.get("name") or ""
    if "-yanked" in name:
        continue
    if r.get("prerelease"):
        continue
    major = name.split(".", 1)[0]
    if major not in majors:
        majors[major] = r
        ordered.append(major)

print(json.dumps([majors[m] for m in ordered]))
PY
<<<"$releases_info")

echo "Found major_releases"
echo "${major_releases}"

latest_version=$(echo "$release_info" | jq -r .name)
latest_url=$(echo "$release_info" | jq -r '.assets | .[] | .browser_download_url' | grep darwin)

prerelease_version=$(echo "$prerelease_info" | jq -r .name)
prerelease_url=$(echo "$prerelease_info" | jq -r '.assets | .[] | .browser_download_url' | grep darwin)

rm -f ./release.zip
curl -L -o release.zip "${latest_url}"
latest_checksum=$(sha256sum release.zip | cut -d " " -f 1)

rm -f ./prerelease.zip
curl -L -o prerelease.zip "${prerelease_url}"
prerelease_checksum=$(sha256sum prerelease.zip | cut -d " " -f 1)

echo "cask \"logsmith\" do
  version \"${latest_version}\"
  homepage \"ttps://github.com/otto-de/logsmith\"
  sha256 \"${latest_checksum}\"
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

echo "$major_releases" | jq -c '.[]' | while read -r release; do
  major_version=$(echo "$release" | jq -r .name)
  major_url=$(echo "$release" | jq -r '.assets | .[] | .browser_download_url' | grep darwin)
  major="${major_version%%.*}"

  rm -f "./release-${major}.zip"
  curl -L -o "./release-${major}.zip" "${major_url}"
  major_checksum=$(sha256sum "./release-${major}.zip" | cut -d " " -f 1)

  echo "cask \"logsmith@${major}\" do
  version \"${major_version}\"
  homepage \"https://github.com/otto-de/logsmith\"
  sha256 \"${major_checksum}\"
  url \"https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip\"
  app \"dist/logsmith.app\"
end" > "./Casks/logsmith@${major}.rb"
done
