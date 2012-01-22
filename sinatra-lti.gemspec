# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sinatra-lti/version"

Gem::Specification.new do |s|
  s.name        = "sinatra-lti"
  s.version     = SinatraLti::VERSION
  s.authors     = ["tom metge"]
  s.email       = ["tom@instructure.com"]
  s.homepage    = ""
  s.summary     = %q{Framework for an LTI-enabled Sinatra application}
  s.description = %q{Framework for an LTI-enabled Sinatra application}

  s.rubyforge_project = "sinatra-lti"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
