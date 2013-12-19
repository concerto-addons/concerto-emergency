$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "concerto_emergency_broadcast/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "concerto-emergency-broadcast"
  s.version     = ConcertoEmergencyBroadcast::VERSION
  s.authors     = "Concerto Team"
  s.email       = ["team@concerto-signage.org"]
  s.homepage    = "http://concerto-signage.org"
  s.summary     = "Broadcast emergency alerts on Concerto screens."
  s.description = "Broadcast emergency alerts on Concerto screens."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.9"

  s.add_development_dependency "sqlite3"
end
