# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'easy_timers/version'

Gem::Specification.new do |spec|
  spec.name          = "easy_timers"
  spec.version       = EasyTimers::VERSION
  spec.authors       = ["Bryan Hockey"]
  spec.email         = ["bryan.hockey@peimhal.com"]
  spec.summary       = %q{Easily create and manage asynchronous timers using dates or durations.}
  spec.description   = %q{Easily create and manage asynchronous timers using dates or durations.}
  spec.homepage      = "http://github.com/malakai97/easy_timers"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
