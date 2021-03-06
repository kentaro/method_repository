# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'method_repository/version'

Gem::Specification.new do |gem|
  gem.name          = "method_repository"
  gem.version       = MethodRepository::VERSION
  gem.authors       = ["Kentaro Kuribayashi"]
  gem.email         = ["kentarok@gmail.com"]
  gem.description   = %q{Extracting redundant code and commonalizing it in a different way.}
  gem.summary       = %q{Extracting redundant code and commonalizing it in a different way}
  gem.homepage      = "https://github.com/kentaro/method_repository"

  gem.required_ruby_version = '>= 1.9.2'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec", "~> 2.12"
  gem.add_development_dependency "rake"
end
