# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cinch/plugins/twitch/version'

Gem::Specification.new do |spec|
  spec.name          = 'cinch-twitch'
  spec.version       = Cinch::Plugins::TwitchTV::VERSION
  spec.authors       = ['Brian Haberer']
  spec.email         = ['bhaberer@gmail.com']
  spec.description   = %q{Cinch Plugin for monitoring TwitchTV streams}
  spec.summary       = %q{Cinch TwitchTV Plugin}
  spec.homepage      = 'https://github.com/bhaberer/cinch-twitch'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency  'rake'
  spec.add_development_dependency  'rspec'
  spec.add_development_dependency  'coveralls'
  spec.add_development_dependency  'cinch-test'

  spec.add_dependency              'cinch',           '~> 2.0.12'
  spec.add_dependency              'twitch'
  spec.add_dependency              'time-lord'
end
