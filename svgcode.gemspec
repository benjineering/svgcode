lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'svgcode/version'

Gem::Specification.new do |spec|
  spec.name = 'svgcode'
  spec.version = Svgcode::VERSION
  spec.authors = ['Ben Williams']
  spec.email = ['8enwilliams@gmail.com']

  spec.summary = 'A Ruby gem to convert SVG to 2.5D Gcode'
  spec.homepage = 'https://github.com/benjineering/svgcode'
  spec.license = 'MIT'
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables = [ 'svgcode' ]
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-shell'

  spec.add_dependency 'nokogiri', '~> 1.8'
  spec.add_dependency 'thor', '~> 0.20'
end
