# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "murky/version"

Gem::Specification.new do |spec|
  spec.name          = "murky_waters"
  spec.version       = Murky::VERSION
  spec.authors       = ["Wouter Coppieters"]
  spec.email         = ["wouter@youdo.co.nz"]

  spec.summary       = "Merkle Tree backed Dictionary"
  spec.description   = "A simple implementation of a Merkle Tree backed Dictionary"
  spec.homepage      = "https://github.com/wouterken/murky_waters"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "http://mygemserver.com"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency "pry"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~>5.8.4"
end
