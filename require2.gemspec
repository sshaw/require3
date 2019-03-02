require File.expand_path("../lib/require2", __FILE__)
require "date"

Gem::Specification.new do |s|
  s.name        = "require2"
  s.version     = Require2::VERSION
  s.date        = Date.today
  s.summary     = ""
  s.description =<<-DESC
  DESC
  s.authors     = ["Skye Shaw"]
  s.email       = "skye.shaw@gmail.com"
  s.test_files  = Dir["test/**/*.*"]
  s.files       = Dir["lib/**/*.rb"] + s.test_files
  s.homepage    = "http://github.com/sshaw/require2"
  s.license     = "MIT"
  s.add_development_dependency "rake"
  s.add_development_dependency "minitest", "~> 5.0"
end
