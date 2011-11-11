# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "json_matcher/version"

Gem::Specification.new do |s|
  s.name        = "json_matcher"
  s.version     = JsonMatcher::VERSION
  s.authors     = ["Garima Singh"]
  s.email       = ["garima.slideshare@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "json_matcher"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "term-ansicolor"

  s.add_development_dependency "rspec"
end
