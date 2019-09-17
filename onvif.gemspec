
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "onvif/version"

Gem::Specification.new do |spec|
  spec.name          = "onvif"
  spec.version       = Onvif::VERSION
  spec.authors       = ["Ministry of Velocity"]
  spec.email         = ["pair@ministryofvelocity.com"]
  spec.summary       = %q{Talk to IP Cameras using ONVIF.}
  spec.homepage      = "https://github.com/minifast/onvif"
  spec.license       = "MIT"
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
