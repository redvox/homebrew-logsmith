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

function release_has_app_bundle() {
  local name=$1
  local url=$2

  local archive="./${name}.zip"

  echo -e "${cy}    Validate app bundle in ${url}${cc}" >&2
  rm -f "${archive}"
  curl -L -o "${archive}" "${url}" >/dev/null

  if unzip -Z1 "${archive}" | grep -q '^dist/logsmith\.app/$'; then
    rm -f "${archive}"
    return 0
  fi

  rm -f "${archive}"
  return 1
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

function select_latest_release_with_app_bundle() {
  local prerelease=$1
  local selected=""

  while IFS= read -r release; do
    [ -z "${release}" ] && continue

    local version
    local url
    version=$(jq_name "${release}")
    url=$(jq_url "${release}")

    if release_has_app_bundle "${version}" "${url}"; then
      selected="${release}"
      break
    fi

    echo -e "${cy}    Skip ${version} (missing dist/logsmith.app)${cc}" >&2
  done < <(echo "$releases_info" | jq -c --argjson prerelease "${prerelease}" '.[] | select((.name | contains("-yanked") | not) and (.prerelease == $prerelease))')

  if [ -z "${selected}" ]; then
    echo ""
    return 1
  fi

  echo "${selected}"
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
release_info=$(select_latest_release_with_app_bundle false)
prerelease_info=$(select_latest_release_with_app_bundle true || true)

if [ -z "$release_info" ]; then
  echo -e "${cr}[!] No stable release with dist/logsmith.app found${cc}" >&2
  exit 1
fi

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
if [ -z "${prerelease_info}" ]; then
  write_cask "logsmith-beta" "${latest_version}" "${latest_checksum}"
  echo -e "${cy}    Latest beta version: ${latest_version} (no prerelease with app bundle found)${cc}"
else
  prerelease_version=$(jq_name "$prerelease_info")
  prerelease_url=$(jq_url "$prerelease_info")
  if [ "${latest_version}" != "${prerelease_version}" ] && [ "$(printf '%s\n' "${latest_version}" "${prerelease_version}" | sort -V | tail -n1)" = "${latest_version}" ]; then
    write_cask "logsmith-beta" "${latest_version}" "${latest_checksum}"
    echo -e "${cg}    Latest beta version: ${latest_version} (stable is higher)${cc}"
  else
    prerelease_checksum=$(get_checksum "beta" "${prerelease_url}")
    write_cask "logsmith-beta" "${prerelease_version}" "${prerelease_checksum}"
    echo -e "${cg}    Latest beta version: ${prerelease_version}${cc}"
  fi
fi


echo -e "${cg}[+] Update all major releases${cc}"
echo "$major_releases" | jq -c '.[]' | while read -r release; do
  major_version=$(jq_name "$release")
  major_url=$(jq_url "$release")
  major="${major_version%%.*}"

  echo -e "${cg}   ${major_version}:${cc}"
  major_checksum=$(get_checksum "${major_version}" "${major_url}")
  write_cask "logsmith@${major}" "${major_version}" "${major_checksum}"
done
