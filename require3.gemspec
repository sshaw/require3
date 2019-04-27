require File.expand_path("../lib/require3/version", __FILE__)
require "date"

Gem::Specification.new do |s|
  s.name        = "require3"
  s.version     = Require3::VERSION
  s.date        = Date.today
  s.summary     = "Kernel#require something and make its contents accessible via a different namespace."
  s.authors     = ["Skye Shaw"]
  s.email       = "skye.shaw@gmail.com"
  s.test_files  = Dir["test/**/*.*"]
  s.files       = Dir["lib/**/*.rb"] + s.test_files
  s.homepage    = "http://github.com/sshaw/require3"
  s.license     = "MIT"
  s.add_dependency "alias2"
  s.add_development_dependency "bundler", "~> 1.8"
  s.add_development_dependency "rake"
  s.add_development_dependency "minitest", "~> 5.0"
end
