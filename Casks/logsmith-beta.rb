cask "logsmith-beta" do
  version "11.0.0-rc.2"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "4cd2213e2e1210a8e3ea24c537f533fc94b0d95cc58b9fe45338e7752d029405"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
