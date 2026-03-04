cask "logsmith-beta" do
  version "11.0.0-rc.2"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "90aa694f9902dad9f8f1976eb7d512d8301c91ed43ee60e996301c6717dc4fef"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
