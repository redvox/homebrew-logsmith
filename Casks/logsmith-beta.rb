cask "logsmith-beta" do
  version "9.1.0-rc.2"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "323b572063679f4cb56d6adc23785bcf72a699e0ac50678868dc76dd48a7587d"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
