# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "crawler"
  spec.version       = "1.0"
  spec.authors       = ["Nick Gauthier"]
  spec.email         = ["ngauthier@gmail.com"]
  spec.summary       = %q{Simple web crawler}
  spec.description   = %q{Stores assets and links of a given domain}
  spec.homepage      = "http://github.com/ngauthier/crawler"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "simplecov", "~> 0.9.0"
end
