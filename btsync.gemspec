# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'btsync/version'

Gem::Specification.new do |spec|
  spec.name          = "btsync_api"
  spec.version       = BtsyncApi::VERSION
  spec.authors       = ["Pascal Jungblut"]
  spec.email         = ["mail@pascal-jungblut.com"]
  spec.description   = %q{Wrapper for the BitTorrent Sync API}
  spec.summary       = %q{A thin wrapper around the BitTorrent Sync API. It abstracts the request into method calls and returns parsed JSON.}
  spec.homepage      = "http://github.com/pascalj/btsync"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
