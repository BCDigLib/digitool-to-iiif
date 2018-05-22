# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dtliiif/version"

Gem::Specification.new do |spec|
  spec.name          = "dtliiif"
  spec.version       = Dtliiif::VERSION
  spec.authors       = ["Adam Jazairi"]
  spec.email         = ["adam.jazairi@bc.edu"]

  spec.summary       = "Converts DigiTool metadata to IIIF"
  spec.description   = "Generates IIIF manifests from DigiTool digital entity files"
  spec.homepage      = "https://library.bc.edu"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'nokogiri', "~> 1.6"
  spec.add_runtime_dependency 'iiif-presentation', "~> 0.2"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
