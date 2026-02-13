cask "logsmith-beta" do
  version "10.1.0-rc.3"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "62584c7763216c365173d2784226f97d7393425a87e3fa86f6363c27621dd24b"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
