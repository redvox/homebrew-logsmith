cask "logsmith-beta" do
  version "11.0.0-rc.1"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "7e58d15f3a6f0c9b99d0221354ad667463b09255e175555565aef2b1b1d86b67"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
