cask "logsmith-beta" do
  version "9.1.0-rc.1"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "18b87f34c7b42cc4fa16c36d17ced6dd0be11c5153e14186c84050b11340c455"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
