# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'log_view/version'

Gem::Specification.new do |spec|
  spec.name          = "log_view"
  spec.version       = LogView::VERSION
  spec.authors       = ["marcos.ocf01"]
  spec.email         = ["marcos.ocf01@gmail.com"]
  spec.summary       = %q{log_view is a parallel monitoring logs gem}
  spec.description   = %q{log_view is a parallel monitoring logs gem who uses ssh connection to make tail on described files in multiple servers}
  spec.homepage      = "https://github.com/MarcosOcf/log_view"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "net-ssh", "~> 2.8.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.3.0"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency "byebug", "~> 3.1.2"
end
