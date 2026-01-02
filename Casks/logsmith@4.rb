cask "logsmith@4" do
  version "4.1.0"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "76dbd18546c7b9196ce04d21553fc16b350afbf54ec51c44a7998f759aaf021b"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
