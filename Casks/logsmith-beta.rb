cask "logsmith-beta" do
  version "11.1.0-rc.1"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "78a6bfc2d57e4eb01efdf5ff4163bd423cefa3574db60bece1ac5e49736a0b41"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
