# -*- encoding: utf-8 -*-
require File.expand_path('../lib/grape/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Julien Ammous"]
  gem.email         = ["schmurfy@gmail.com"]
  gem.description   = %q{API Browser}
  gem.summary       = %q{Generate browseable api from your Grape services}
  gem.homepage      = ""
  
  if false
    gem.files         = `git ls-files`.split($\)
    gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  end
  
  gem.name          = "grape_apidoc"
  gem.require_paths = ["lib"]
  gem.version       = Grape::Apidoc::VERSION
end
