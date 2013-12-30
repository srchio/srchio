$:.push File.expand_path("../lib", __FILE__)
require "srchio/version"

Gem::Specification.new do |s|
  s.name        = "srchio"
  s.version     = Srchio::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kevin Lawver"]
  s.email       = ["support@srch.io"]
  s.homepage    = "http://github.com/railsmachine/srchio"
  s.summary     = %q{The official gem for srch.io! Makes searching fun and easy.}
  s.description = %q{The official gem and wrapper for the srch.io API. More info @ http://srch.io}

  s.required_ruby_version     = '>= 1.9.3'

  s.add_dependency 'httparty',      ">= 0.12.0"

  s.post_install_message = "Hooray, you've installed srchio! Thanks!"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end