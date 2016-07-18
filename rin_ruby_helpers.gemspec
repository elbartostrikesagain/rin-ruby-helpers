# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rin_ruby_helpers/version'

Gem::Specification.new do |spec|
  spec.name          = "rin_ruby_helpers"
  spec.version       = RinRubyHelpers::VERSION
  spec.authors       = ["Calvin Delamere"]
  spec.email         = ["calvin.delamere@gmail.com"]
  spec.description   = %q{Adds helper methods to rinruby}
  spec.summary       = %q{Adds helper methods to rinruby}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"
end
