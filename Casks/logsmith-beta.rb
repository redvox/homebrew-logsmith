cask "logsmith-beta" do
  version "10.0.0"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "145aab3940b89bbb5664451120ab92047826f5a3503bcbba67b244ca809d6f63"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
