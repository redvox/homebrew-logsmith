cask "logsmith-beta" do
  version "9.1.0-rc.3"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "7f495ee880786626a67ca48729b76a6ff9ecf73fa9c29228d5885bda80499b2d"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
