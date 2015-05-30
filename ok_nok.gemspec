# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ok_nok/version"

Gem::Specification.new do |s|
  s.name        = "ok_nok"
  s.version     = OkNok::VERSION
  s.authors     = ["Patrick Gleeson"]
  s.email       = ["hello@patrickgleeson.com"]
  s.homepage    = "https://github.com/patrick-gleeson"
  s.summary     = %q{Success-failure utility}
  s.description = %q{A utility for adding a variant of functional-style Either return values to Ruby code.}
  s.license     = "MIT"

  s.rubyforge_project = "ok_nok"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
end
