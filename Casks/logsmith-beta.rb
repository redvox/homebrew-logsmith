cask "logsmith-beta" do
  version "10.1.0-rc.2"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "928d14493ba53a905432e1312c14b4016b20614b7ebc896dbdee92abf80f60a9"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
