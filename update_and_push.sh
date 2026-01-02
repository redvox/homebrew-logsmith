#!/usr/bin/env bash

./update_cask.sh

git add ./Casks/* && git commit -am "update cask" && git push || echo "Nothing to import."