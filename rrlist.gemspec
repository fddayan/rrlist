# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rrlist/version"

Gem::Specification.new do |s|
  s.name        = "rrlist"
  s.version     = Rrlist::VERSION
  s.authors     = ["Federico Dayan"]
  s.email       = ["federico.dayan@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "rrlist"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency "trollop"
  s.add_dependency "rainbow"
  s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
