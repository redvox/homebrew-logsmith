cask "logsmith@5" do
  version "5.0.0"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "25ed05fecc1feeb8b2cfbcab2554070dc9a5ad16bffce9081b8160274311651e"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
