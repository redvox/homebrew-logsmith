cask "logsmith@11" do
  version "11.0.0"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "7fe2ed1379b36bb8d4c4cb0afb1d4b0a94bde8f2734147124731ac6b50864aba"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
