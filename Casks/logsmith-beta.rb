cask "logsmith-beta" do
  version "11.0.2-rc.1"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "7ca571d74ef132ce7f24b143bad0defe62de34eb4366cad1826c375a7ce08656"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
