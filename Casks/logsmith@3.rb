cask "logsmith@3" do
  version "3.1.0"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "1ca931dec89a141851b1582f249891d91cf7ca7664dd7143fca622178f51c1ff"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
