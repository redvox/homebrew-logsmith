cask "logsmith" do
  version "11.0.2"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "062041ee7d104cebdb12dbb624ae8e69716ad29b27778128cf201f90236c6f6a"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
