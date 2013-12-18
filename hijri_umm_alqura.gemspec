# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hijri_umm_alqura/version'

Gem::Specification.new do |spec|
  spec.name          = "hijri_umm_alqura"
  spec.version       = HijriUmmAlqura::VERSION
  spec.authors       = ["Mohammed Alsheikh"]
  spec.email         = ["msheikh2009@yahoo.com"]
  spec.description   = %q{Class to convert hijri to/from Julian Date.}
  spec.summary       = %q{Hijri Umm Alqura date object}
  spec.homepage      = "https://github.com/moh-alsheikh/hijriummalqura"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.files = Dir["README.md","Gemfile","Rakefile", "lib/**/*"]
  
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
