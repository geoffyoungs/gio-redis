# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gio/redis/version'

Gem::Specification.new do |spec|
  spec.name          = "gio-redis"
  spec.version       = Gio::Redis::VERSION
  spec.authors       = ["Geoff Youngs\n"]
  spec.email         = ["git@intersect-uk.co.uk"]
  spec.description   = %q{Minimal Redis message client for use with the Ruby-GNOME2 gio2 bindings.}
  spec.summary       = %q{gio2 based redis pub/sub listener}
  spec.homepage      = "http://github.com/geoffyoungs/gio-redis"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'hiredis'
  spec.add_dependency 'gio2'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "gtk2"
end
