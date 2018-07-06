# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'limiter/version'

Gem::Specification.new do |spec|
  spec.name          = 'limiter'
  spec.version       = Limiter::VERSION
  spec.authors       = ['S. Brent Faulkner']
  spec.email         = ['brent.faulkner@shopify.com']

  spec.summary       = 'Simple Ruby rate limiting mechanism.'
  spec.homepage      = 'https://github.com/Shopify/limiter'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.56'
  spec.add_development_dependency 'timecop', '~> 0.8.0'
end
