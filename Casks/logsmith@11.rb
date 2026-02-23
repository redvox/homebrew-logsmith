cask "logsmith@11" do
  version "11.0.0-rc.1"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "38a8e0e9be25d9fb7119c6df87ee444c45fa906f75e74fcf9abc3fa186b64729"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
