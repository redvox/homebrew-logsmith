cask "logsmith@11" do
  version "11.0.1"
  homepage "https://github.com/otto-de/logsmith"
  sha256 "3e7f97bfeda382cc932a855d9d7f2ce1e444ab3ebbff25c2988d20ad6521c0d9"
  url "https://github.com/otto-de/logsmith/releases/download/#{version}/logsmith_darwin_#{version}.zip"
  app "dist/logsmith.app"
end
