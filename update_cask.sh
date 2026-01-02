#!/usr/bin/env bash
c="\x1b[1m"
co="${c}\x1b[38;5;208m"
cb="${c}\x1b[34m"
cr="${c}\x1b[31m"
cg="${c}\x1b[32m"
cy="${c}\x1b[93m"
cc="\x1b[0m"

set -ueo pipefail

function get_checksum(){
  local name=$1
  local url=$2

  echo -e "${cg}    Download file from ${url}${cc}" >&2

  rm -f "./${name}.zip"
  curl -L -o "./${name}.zip" "${url}"
  checksum=$(sha256sum "./${name}.zip" | cut -d " " -f 1)
  rm -f "./${name}.zip"

  echo -e "${cg}    Checksum ${checksum}${cc}" >&2
  echo "${checksum}"
}

function write_cask(){
  local name=$1
  local version=$2
  local checksum=$3

  echo "cask \"${name}\" do
  version \"${version}\"
  homepage \"https://github.com/otto-de/logsmith\"
  sha256 \"${checksum}\"
  url \"https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip\"
  app \"dist/logsmith.app\"
end" > "./Casks/${name}.rb"
}

function jq_name(){
  local data=$1
  echo "$data" | jq -r .name
}

function jq_url(){
  local data=$1
  echo "$data" | jq -r '.assets | .[] | .browser_download_url' | grep darwin
}

if [ -z "$GITHUB_TOKEN" ]; then
  echo -e "${cr}[!] GITHUB_TOKEN is not set${cc}" >&2
  exit 1
fi

echo -e "${cg}[+] Fetch release data${cc}"
releases_info=$(curl \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: ${GITHUB_TOKEN}" https://api.github.com/repos/otto-de/logsmith/releases)
echo "$releases_info" > releases_info.json

if [ -z "$releases_info" ]; then
  echo -e "${cr}[!] Empty response from GitHub API${cc}" >&2
  exit 1
fi

if [ ! -s releases_info.json ]; then
  echo -e "${cr}[!] releases_info.json is empty${cc}" >&2
  exit 1
fi

if ! echo "$releases_info" | jq -e . >/dev/null; then
  echo -e "${cr}[!] Invalid JSON in releases_info.json${cc}" >&2
  exit 1
fi

echo -e "${cg}[+] Extract releases${cc}"
# Filter out releases where .name contains "-yanked" or "prerelease" is true, get the latest one
release_info=$(echo "$releases_info" | jq -c '[.[] | select((.name | contains("-yanked") | not) and (.prerelease | not))] | first')
prerelease_info=$(echo "$releases_info" | jq -c '[.[] | select((.name | contains("-yanked") | not) and (.prerelease))] | first')
major_releases=$(python3 - <<'PY'
import json

with open("releases_info.json", "r", encoding="utf-8") as f:
    data = json.load(f)
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
)

echo -e "${cg}[+] Update Latest stable${cc}"
latest_version=$(jq_name "$release_info")
latest_url=$(jq_url "$release_info")
latest_checksum=$(get_checksum "latest" "${latest_url}")
write_cask "logsmith" "${latest_version}" "${latest_checksum}"
echo -e "${cg}    Latest stable version: ${latest_version}${cc}"

echo -e "${cg}[+] Update Latest beta${cc}"
prerelease_version=$(jq_name "$prerelease_info")
prerelease_url=$(jq_url "$prerelease_info")
prerelease_checksum=$(get_checksum "beta" "${prerelease_url}")
write_cask "logsmith-beta" "${prerelease_version}" "${prerelease_checksum}"
echo -e "${cg}    Latest beta version: ${prerelease_version}${cc}"


echo -e "${cg}[+] Update all major releases${cc}"
echo "$major_releases" | jq -c '.[]' | while read -r release; do
  major_version=$(jq_name "$release")
  major_url=$(jq_url "$release")
  major="${major_version%%.*}"

  echo -e "${cg}   ${major_version}:${cc}"
  major_checksum=$(get_checksum "${major_version}" "${major_url}")
  write_cask "logsmith@${major}" "${major_version}" "${major_checksum}"
done
