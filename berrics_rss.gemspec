# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'berrics_rss/version'

Gem::Specification.new do |gem|
  gem.name          = "berrics_rss"
  gem.version       = BerricsRss::VERSION
  gem.summary       = %q{BerricsRss creates an RSS feed from theberrics.com website}
  gem.description   = gem.summary

  gem.required_ruby_version = '>= 1.9.3'
  gem.license       = "MIT"

  gem.authors       = ["Derek DeVries"]
  gem.email         = ["derek@sportspyder.com"]
  gem.homepage      = "http://sportspyder.com"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_runtime_dependency("nokogiri", "~> 1.5")
  gem.add_runtime_dependency("builder",  "~> 3.1")
  gem.add_development_dependency("rake")
end
