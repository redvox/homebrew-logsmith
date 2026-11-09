cask "logsmith@11" do
  version "11.1.0"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "39d68219f20b37f1b4fabee046c4ba7062f110d0f93c10b8b151ca3f899c0492"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
