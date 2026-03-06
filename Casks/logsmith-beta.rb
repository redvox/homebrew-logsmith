cask "logsmith-beta" do
  version "11.0.1-rc.1"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "9b7652c55e7232bd58182eef09171db29715cfa4eec3b382e63bc80684bd4b37"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
