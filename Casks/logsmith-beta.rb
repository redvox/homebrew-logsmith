cask "logsmith-beta" do
  version "11.0.0-rc.2"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "f97feaf6faabea1195df9a4fc97c542196e759e9af2024ff8f52909667ba1678"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
