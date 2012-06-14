# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "guard/pusher/version"

Gem::Specification.new do |s|
  s.name        = "guard-pusher"
  s.version     = Guard::PusherVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Klaus Hartl"]
  s.email       = ["klaus.hartl@gmail.com"]
  s.homepage    = "http://github.com/carhartl/guard-pusher"
  s.summary     = "Guard gem for Pusher"
  s.description = "Pusher guard allows to automatically send a Pusher message to any number of browsers."

  s.rubyforge_project = "guard-pusher"

  s.add_dependency "guard", ">= 0.3"
  s.add_dependency "pusher", ">= 0.8"

  s.add_development_dependency "bundler", "~> 1"
  s.add_development_dependency "rspec", "~> 2"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rb-fsevent"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
