Gem::Specification.new do |spec|
  spec.name          = 'lita-wtf'
  spec.version       = '1.2.0'
  spec.authors       = ['Eric Sigler', 'Rob Ottaway', 'Max T']
  spec.email         = ['me@esigler.com', 'rottaway@pagerduty.com', 'github@maxvt.com']
  spec.description   = 'A user-controlled dictionary plugin for Lita'
  spec.summary       = spec.description
  spec.homepage      = 'http://github.com/esigler/lita-wtf'
  spec.license       = 'MIT'
  spec.metadata      = { 'lita_plugin_type' => 'handler' }

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lita', '>= 4.0'
  spec.add_runtime_dependency 'nokogiri'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop', '0.39.0'
  spec.add_development_dependency 'simplecov'
end
