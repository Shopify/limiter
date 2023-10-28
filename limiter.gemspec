# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'limiter/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby-limiter'
  spec.version       = Limiter::VERSION
  spec.authors       = ['S. Brent Faulkner']
  spec.email         = ['brent.faulkner@shopify.com']

  spec.summary       = 'Simple Ruby rate limiting mechanism.'
  spec.homepage      = 'https://github.com/Shopify/limiter'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'minitest', '~> 5.20'
  spec.add_development_dependency 'minitest-focus', '~> 1.4'
  spec.add_development_dependency 'mocha', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 1.57'
  spec.add_development_dependency 'code-scanning-rubocop', '~> 0.6.1'
  spec.add_development_dependency 'rubocop-shopify', '~> 2.14'
end
